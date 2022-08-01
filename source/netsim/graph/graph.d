/**
 * Functionality for parsing and traveling the netsim graph.
 * Also contains the GraphNode interface and helper mixins for implementing nodes.
 */
module netsim.graph.graph;

// Full import needed
// (fixes error unknown identifier _d_toObject or rt_detachDisposeEvent)
public import std.signals;

import std.conv : to;
import std.exception : enforce;
import std.format : format;
import std.json : JSONValue;
import std.string : capitalize;
import std.uni : isAlpha, isAlphaNum;

import pegged.grammar;

//                          //
// Parsed request structure //
//                          //

/** 
 * The parser returns this after successfully parsing a request.
 *
 * A request string will get parsed as follows: `[RequestType] [GraphPath]`.
 * Note that the RequestType is case-insensitive. (TODO: consider only allowing lowercase )
 */
struct Request
{
  RequestType type;
  GraphPath path;
}

/// First part of a Request
enum RequestType
{
  Query,
  Subscribe,
  Unsubscribe
}

/** 
 * Second part of a Request
 *
 * A GraphPath string will get parsed as follows:
 *   `[GraphPathSegment].[GraphPathSegment].[GraphPathSegment]...`
 */
struct GraphPath
{
  GraphPathSegment[] segments;
}

/** 
 * A method call with arguments.
 * If the segment is the last one in a GraphPath this can also be a signal (with no arguments).
 *
 * A GraphPathSegment string will get parsed as follows:
 *   - `[name]([args])` (if RequestType was Query)
 *   - `[name]` (if RequestType was Subscribe/Unsubscribe)
 */
struct GraphPathSegment
{
  /// Method or signal name
  string name;
  /// Method arguments (empty if name refers to a signal)
  string[] args;
}

//         //
// Parsing //
//         //

mixin(grammar(`
RequestGrammar:
  Request          <- RequestType ' ' GraphPath :eoi
  RequestType      <- "query" / "subscribe" / "unsubscribe"
  GraphPath        <- GraphPathSegment ('.' GraphPathSegment)* ('.' SignalName)?
  GraphPathSegment <- Name Args
  SignalName       <- Name
  Name             <- identifier
  Args             <- "()" / '(' Arg (',' Arg)* ')'
  Arg              <- String / Char / Int / Float / Bool

  String <~ doublequote (!doublequote Character)* doublequote
  Char   <~ quote (!quote Character) quote
  Int    <~ Integer / Hexadecimal / Binary
  Float  <~ Floating / Scientific
  Bool   <~ Boolean

  Character <~ . / EscapeSequence

  EscapeSequence <~ backslash (
    doublequote
    / quote
    / backslash
    / [bfnrt]
    / [0-2][0-7][0-7]
    / [0-7][0-7]?
    / 'x' Hex Hex
    / 'u' Hex Hex Hex Hex
    / 'U' Hex Hex Hex Hex Hex Hex Hex Hex
  )

  Scientific <~ Floating ([eE] Integer)?
  Floating   <~ Integer ('.' Unsigned)?

  Unsigned <~ [0-9]+
  Integer  <~ Sign? Unsigned
  Sign     <- [-+]

  Binary      <~ "0b" [01] [01_]*
  Hexadecimal <~ "0x" Hex+
  Hex <- [0-9a-fA-F]

  Boolean <- "true" / "false"
`));

Request parseRequest(string reqStr)
{
  ParseTree parseTree = RequestGrammar(reqStr);
  if (!parseTree.successful)
  {
    throw new Exception("Error parsing: \"" ~ parseTree.failMsg ~ "\"");
  }

  Request request;

  bool foundSignal = false;

  void processSubtree(ParseTree subtree)
  {
    switch (subtree.name)
    {
    case "RequestGrammar.RequestType":
      request.type = subtree.matches[0].capitalize.to!RequestType;
      break;
    case "RequestGrammar.GraphPathSegment":
      request.path.segments ~= GraphPathSegment();
      break;
    case "RequestGrammar.SignalName":
      enforce(request.type == RequestType.Subscribe || request.type == RequestType.Unsubscribe,
        "Error parsing: the GraphPath resolves to a signal but the RequestType isn't (un)subscribe"
      );
      request.path.segments ~= GraphPathSegment();
      foundSignal = true;
      break;
    case "RequestGrammar.Name":
      request.path.segments[$ - 1].name = subtree.matches[0];
      break;
    case "RequestGrammar.Arg":
      assert(subtree.matches.length == 1); // checks if <~ was used on all types
      string arg = subtree.matches[0];
      // Remove double quotes from strings
      // if (subtree.children[0].name == "RequestGrammar.String")
      // {
      //   assert(arg.length == 2 && arg[0] == '"' && arg[$ - 1] == '"');
      //   arg = arg[1 .. $ - 1]; // 
      // }
      request.path.segments[$ - 1].args ~= arg;
      break;
    default:
      break;
    }

    foreach (child; subtree.children)
      processSubtree(child);
  }

  // The root is the first grammar line: RequestGrammar.Request
  processSubtree(parseTree);

  if (request.type == RequestType.Subscribe || request.type == RequestType.Unsubscribe)
  {
    enforce(foundSignal, "The request type is (un)subscibe but the GraphPath doesn't resolve to a signal");
  }

  return request;
}

@("Test parseRequest")
unittest
{
  Request req = parseRequest("query project(\"some-uuid\").getSomeNode().doSomething(true,'a',1)");

  assert(req.type == RequestType.Query);
  assert(req.path.segments.length == 3);

  assert(req.path.segments[0].name == "project");
  assert(req.path.segments[0].args.length == 1);
  assert(req.path.segments[0].args[0] == "\"some-uuid\"");

  assert(req.path.segments[1].name == "getSomeNode");
  assert(req.path.segments[1].args.length == 0);

  assert(req.path.segments[2].name == "doSomething");
  assert(req.path.segments[2].args.length == 3);
  assert(req.path.segments[2].args[0] == "true");
  assert(req.path.segments[2].args[1] == "'a'");
  assert(req.path.segments[2].args[2] == "1");
}

//             //
// Graph nodes //
//             //

/** 
 * Every class that is part of the netsim graph needs to implement this interface.
 * 
 * When executing a Request, resolve will be called on the GraphNodes with all but the last GraphPathSegment.
 * On the GraphNode at the end of the path, one of the other 3 methods will be called based on the RequestType.
 */
interface GraphNode
{
  /** 
   * Calls the method referred to by `segment` and returns its result: a GraphNode child.
   * Params:
   *   segment = Any but the last segment of a Query, with type = Method.
   * Returns: The GraphNode child on which the next segement should be called upon.
   */
  GraphNode resolve(in GraphPathSegment segment);

  /** 
   * Calls the method referred to by `segment` and returns its result: a string.
   * Params:
   *   segment = The last segment of a Query, with type = Method.
   * Returns: The result of the method referred to by `segment`, that should be sent to the client.
   */
  string query(in GraphPathSegment segment);

  /** 
   * Every time the signal referred to by `segment` is triggered, calls hook with the value of that signal.
   * Calling this multiple times with the same hook will result in that hook also being called multiple times when the
   * signal triggers.
   * Params:
   *   segment = The last segment of a Query, with type = Signal.
   *   hook = A delegate referring to a class method with signature "void method(string)".
   */
  // void subscribe(in GraphPathSegment segment, void delegate(string) hook);

  /**
   * Removes a hook from the call list of the signal referred to by `segment`.
   * If a hook was added multiple times with multiple `subscribe` calls, all those subscriptions will be undone.
   * Params:
   *   segment = The last segment of a Query, with type = Signal.
   *   hook = A delegate referring to a class method with signature "void method(string)".
   */
  // void unsubscribe(in GraphPathSegment segment, void delegate(string) hook);

  /*
   * Serialize to json.
   */
  JSONValue _toJSON() const @safe;
}

//                                                                   //
// Mixins for easily implementing the GraphNode interface in a class //
//                                                                   //

/// Used by baseResolveQueryMixin
enum ResolveOrQueryEnum : ubyte
{
  Resolve,
  Query
}

/// Shared base template for resolveMixin and queryMixin
template baseResolveQueryMixin(ResolveOrQueryEnum ResolveOrQuery, Methods...)
{
  import netsim.graph.graph : GraphNode, GraphPathSegment, ResolveOrQueryEnum;

  import std.algorithm : map;
  import std.conv : to;
  import std.exception : enforce;
  import std.format : format;
  import std.range : iota, join;
  import std.traits : arity, Parameters;

  import painlessjson : toJSON;

  auto base(in GraphPathSegment segment)
  {
    switch (segment.name)
    {
      // Each case converts the segment.args to the types expected by the method segment.name.
      // Then it calls the method with name segment.name with those arguments and returns the result.
      static foreach (Method; Methods)
      {
        static assert(
          __traits(identifier, Method)[0 .. 6] == "graph_",
          format!"Graph method '%s.%s' has missing graph_ prefix"(
            __traits(parent, Method).stringof, __traits(identifier, Method)
        )
        );
    case __traits(identifier, Method)[6 .. $]: // case MethodName (minus graph_ prefix):
        // This extra scope is just so we can reuse local variable names
        {
          const string MethodName = __traits(identifier, Method);
          const string MethodNameWithoutPrefix = MethodName[6 .. $];
          alias MethodArgCount = arity!Method;
          alias MethodArgTypes = Parameters!Method;

          enforce(segment.args.length == MethodArgCount, format!"Method %s expected %d arguments instead of %d"(
              MethodNameWithoutPrefix, MethodArgCount, segment.args.length
          ));

          // Convert each argument (string) to the type expected by the method
          static foreach (i, Type; MethodArgTypes)
          {
            mixin(format!"Type arg_%d = void;"(i)); // Declare first so we can use try/catch
            try
            {
              static if (is(Type == string)) // Special case for string arguments: remove doublequotes
                mixin(format!"arg_%d = segment.args[%d][1 .. $ - 1];"(i, i));
              else
                mixin(format!"arg_%d = segment.args[%d].to!Type;"(i, i));
            }
            catch (Exception e)
            {
              throw new Exception(format!"Failed to convert string \"%s\" to type %s: %s"(
                  segment.args[i], Type.stringof, e.message));
            }
          }

          // Generate argument list string ("arg_0,arg_1,...")
          const string argsToMixin = iota(MethodArgCount).map!(i => format!"arg_%d"(i)).join(",");

          // Finally, generate the method call
          static if (ResolveOrQuery == ResolveOrQueryEnum.Resolve)
            mixin(format!"return cast(GraphNode) %s(%s);"(MethodName, argsToMixin));
          else static if (ResolveOrQuery == ResolveOrQueryEnum.Query)
            mixin(format!"return %s(%s).toJSON.toString;"(MethodName, argsToMixin));
          else
            static assert(false);
        }
      }

    default:
      throw new Exception(format!"Invalid method name %s"(segment.name));
    }
  }
}

/** 
 * When mixed into a class, this template provides a `resolve` method as in the GraphNode interface.
 * Params:
 *   Methods: List of final methods of the current GraphNode class that return a GraphNode child.
 */
template resolveMixin(Methods...) if (Methods.length > 0)
{
  import netsim.graph.graph : GraphNode, GraphPathSegment;

  GraphNode resolve(in GraphPathSegment segment)
  {
    import netsim.graph.graph : baseResolveQueryMixin, ResolveOrQueryEnum;
    import std.traits : isFinalFunction, ReturnType;

    static foreach (Method; Methods)
    {
      static assert(isFinalFunction!Method);
      static assert(__traits(compiles, {
          ReturnType!Method a;
          GraphNode b = cast(GraphNode) a;
        }));
    }

    mixin baseResolveQueryMixin!(ResolveOrQueryEnum.Resolve, Methods);
    return base(segment);
  }
}

/** 
 * When mixed into a class, this template provides a `query` method as in the GraphNode interface.
 * Params:
 *   Methods: List of final methods of the current class that return a string (usually json).
 */
template queryMixin(Methods...) if (Methods.length > 0)
{
  import netsim.graph.graph : GraphPathSegment;

  string query(in GraphPathSegment segment)
  in (segment.args.length == 0)
  {
    import netsim.graph.graph : baseResolveQueryMixin, ResolveOrQueryEnum;
    import painlessjson : toJSON;
    import std.traits : isFinalFunction, ReturnType;

    static foreach (Method; Methods)
    {
      static assert(isFinalFunction!Method);
      static assert(__traits(compiles, {
          ReturnType!Method a;
          string b = a.toJSON.toString;
        }));
    }
    mixin baseResolveQueryMixin!(ResolveOrQueryEnum.Query, Methods);
    return base(segment);
  }
}

template emptyResolveMixin()
{
  GraphNode resolve(in GraphPathSegment segment)
  {
    assert(false, "This GraphNode has no resolve methods");
  }
}

template emptyQueryMixin()
{
  string query(in GraphPathSegment segment)
  {
    assert(false, "This GraphNode has no query methods");
  }
}

@("Test resolveMixin")
unittest
{
  bool success = false;

  final class A
  {
    GraphNode graph_foo(int a, string b)
    {
      assert(a == 1 && b == "str");
      success = true;
      return null;
    }

    mixin resolveMixin!graph_foo;
  }

  A a = new A;

  GraphPathSegment segment;
  segment.name = "foo";
  segment.args = ["1", "\"str\""];

  assert(a.resolve(segment) is null);
  assert(success);
}

//                 //
// Graph traveling //
//                 //

/** 
 * Travels the graph with a valid Request object.
 * Returns: A json string
 */
string handleRequest(const Request req, GraphNode root) nothrow
{
  try
  {
    assert(req.path.segments.length >= 1);

    GraphNode curr = root;

    foreach (i, segment; req.path.segments)
    {
      bool lastSegment = (i + 1 == req.path.segments.length);

      if (!lastSegment)
        curr = curr.resolve(segment);
      else
      {
        final switch (req.type)
        {
        case RequestType.Query:
          return curr.query(segment);
        case RequestType.Subscribe:
          return ""; //curr.subscribe(segment);
        case RequestType.Unsubscribe:
          return ""; //curr.unsubscribe(segment);
        }
      }
    }
  }
  catch (Exception e)
  {
    try
      return format!"{\"error\": \"%s\"}"(e.msg);
    catch (Exception e)
      return e.msg;
  }
  assert(false);
}

@("Test handleRequest accepting root node")
unittest
{
  final class RootNode : GraphNode
  {
    auto graph_foo()
    {
      return [0, 1, 2];
    }

    mixin emptyResolveMixin;
    mixin queryMixin!graph_foo;

    void subscribe(GraphPathSegment segment, void delegate(string) hook)
    {
    }

    void unsubscribe(GraphPathSegment segment, void delegate(string) hook)
    {
    }

    JSONValue _toJSON() const @safe
    {
      return JSONValue.init;
    }
  }

  RootNode root = new RootNode;
  auto req = Request(RequestType.Query, GraphPath([GraphPathSegment("foo")]));
  string s = handleRequest(req, root);
  assert(s == "[0,1,2]");
}
