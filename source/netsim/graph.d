module netsim.graph;

// Full import needed
// (fixes error unknown identifier _d_toObject or rt_detachDisposeEvent)
public import std.signals;

import std.conv : to;
import std.exception : enforce;
import std.format : format;
import std.uni : isAlpha, isAlphaNum;

/*
  TODO:
    - add request mockup
    - add request and GraphPath parsing
    - add version(GenerateGraphSpec)
*/

///
// Parsed request structure
///

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

///
// Parsing
///

import pegged.grammar;

mixin(grammar(`
PeggedRequest:
    Request          <- RequestType ' ' GraphPath :eoi
    RequestType      <- "query" / "subscribe" / "unsubscribe"
    GraphPath        <- GraphPathSegment ('.' GraphPathSegment)*
    GraphPathSegment <- Name Args
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
  ParseTree parseTree = PeggedRequest(reqStr);
  if (!parseTree.successful)
  {
    throw new Exception("Error parsing: \"" ~ parseTree.failMsg ~ "\"");
  }

  Request request;

  void processSubtree(ParseTree subtree)
  {
    switch (subtree.name)
    {
    case "Request.RequestType":
      request.type = subtree.matches[0].to!RequestType;
      break;
    case "Request.GraphPathSegment":
      request.path.segments ~= GraphPathSegment();
      break;
    case "Request.Name":
      request.path.segments[$ - 1].name = subtree.matches[0];
      break;
    case "Request.Arg":
      assert(subtree.matches.length == 1);
      request.path.segments[$ - 1].args ~= subtree.matches[0];
      break;
    default:
      break;
    }

    foreach (child; subtree.children)
      processSubtree(child);
  }

  // The root is the first grammar line: PeggedRequest.Request
  processSubtree(parseTree);

  return request;
}

@("Test parseRequest")
unittest
{
  Request req = parseRequest("query project(\"some-uuid\").getSomeNode().doSomething(true, 'a', 1)");

  assert(req.type == RequestType.Query);
  assert(req.path.length == 3);

  assert(req.path.segments[0].name == "project");
  assert(req.path.segments[0].args.length == 1);
  assert(req.path.segments[0].args[0] == "\"some-uuid\"");

  assert(req.path.segments[1].name == "getSomeNode");
  assert(req.path.segments[1].path.length == 0);

  assert(req.path.segments[0].name == "doSomething");
  assert(req.path.segments[0].args.length == 3);
  assert(req.path.segments[0].args[0] == "true");
  assert(req.path.segments[0].args[1] == "'a'");
  assert(req.path.segments[0].args[2] == "1");
}

///
// Graph nodes
///

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
  GraphNode resolve(GraphPathSegment segment);

  /** 
   * Calls the method referred to by `segment` and returns its result: a string.
   * Params:
   *   segment = The last segment of a Query, with type = Method.
   * Returns: The result of the method referred to by `segment`, that should be sent to the client.
   */
  string query(GraphPathSegment segment);

  /** 
   * Every time the signal referred to by `segment` is triggered, calls hook with the value of that signal.
   * Calling this multiple times with the same hook will result in that hook also being called multiple times when the
   * signal triggers.
   * Params:
   *   segment = The last segment of a Query, with type = Signal.
   *   hook = A delegate referring to a class method with signature "void method(string)".
   */
  void subscribe(GraphPathSegment segment, void delegate(string) hook);

  /**
   * Removes a hook from the call list of the signal referred to by `segment`.
   * If a hook was added multiple times with multiple `subscribe` calls, all those subscriptions will be undone.
   * Params:
   *   segment = The last segment of a Query, with type = Signal.
   *   hook = A delegate referring to a class method with signature "void method(string)".
   */
  void unsubscribe(GraphPathSegment segment, void delegate(string) hook);
}

///
// Mixins for easily implementing the GraphNode interface in a class
///

/// Used by baseResolveQueryMixin
enum ResolveOrQueryEnum : ubyte
{
  Resolve,
  Query
}

/// Shared base template for resolveMixin and queryMixin
template baseResolveQueryMixin(ResolveOrQueryEnum ResolveOrQuery, Methods...)
{
  import netsim.graph : GraphNode, GraphPathSegment, ResolveOrQueryEnum;

  import std.algorithm : map;
  import std.conv : to;
  import std.exception : enforce;
  import std.format : format;
  import std.range : iota, join;
  import std.traits : arity, Parameters;

  import painlessjson : toJSON;

  auto base(GraphPathSegment segment)
  {
    switch (segment.name)
    {
      // Each case converts the segment.args to the types expected by the method segment.name.
      // Then it calls the method with name segment.name with those arguments and returns the result.
      static foreach (Method; Methods)
      {
    case __traits(identifier, Method): // case MethodName:
        // This extra scope is just so we can reuse local variable names
        {
          const string MethodName = __traits(identifier, Method);
          alias MethodArgCount = arity!Method;
          alias MethodArgTypes = Parameters!Method;

          enforce(segment.args.length == MethodArgCount, format!"Method %s expected %d arguments instead of %d"(
              MethodName, MethodArgCount, segment.args.length
          ));

          // Convert each argument (string) to the type expected by the method
          static foreach (i, Type; MethodArgTypes)
          {
            mixin(format!"Type arg_%d = void;"(i)); // Declare first so we can use try/catch
            try
            {
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
      assert(false, format!"Invalid method name %s"(segment.name));
    }
  }
}

/** 
 * When mixed into a class, this template provides a `resolve` method as in the GraphNode interface.
 * Params:
 *   Methods: List of final methods of the current GraphNode class that return a GraphNode child.
 */
template resolveMixin(Methods...)
{
  import netsim.graph : GraphNode, GraphPathSegment;

  GraphNode resolve(GraphPathSegment segment)
  {
    import netsim.graph : baseResolveQueryMixin, ResolveOrQueryEnum;
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
template queryMixin(Methods...)
{
  import netsim.graph : GraphPathSegment;

  string query(GraphPathSegment segment)
  in (segment.args.length == 0)
  {
    import netsim.graph : baseResolveQueryMixin, ResolveOrQueryEnum;
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

@("Test resolveMixin")
unittest
{
  bool success = false;

  final class A
  {
    GraphNode foo(int a, string b)
    {
      assert(a == 1 && b == "str");
      success = true;
      return null;
    }

    mixin resolveMixin!foo;
  }

  A a = new A;

  GraphPathSegment segment;
  segment.name = "foo";
  segment.args = ["1", "str"];

  assert(a.resolve(segment) is null);
  assert(success);
}

///
// temp
///

/*
  {"type": "query", "query": "getProject(uuid).listNodes()"}
  {"type": "subscribe", "query": "getProject(uuid).listNodes()"}
  {"type": "unsubscribe", "id": "subscription uuid"}

  query getProject(uuid).listNodes()
  subscribe getProject(uuid).listNodes()

  query getProject(uuid)
  subscribe getProject(uuid)


  query getProject(uuid).listNodes()
  returns ["id1": {...}, "id2": ...]

  subscribe getProject(uuid).listNodes()
  returns [subscription uuid]
  sends subsciption [uuid] {contents}

  cancelled using
  unsubscribe [uuid]
*/

/*
  Query:
    parse from:
      getProject(uuid).listNodes()
    to:
      list of QueryParts

  QueryPart: (separated by .)
    parse from:
      getProject(uuid)
      listNodes()
      listNodes
    to:
      function name
      list of QueryArguments
  
  QueryArgument:
    parse from:
      a string
    using: std.conv.to
    to:
      a d type correspording to the function signature
  
  handleQuery(Query) in classes:
    processes the first part
    if there are more parts:
      remove the first part
      call handleQuery(Query) on a child

  no documentation inside protocol
  maybe inside errors
*/

/*
string handleRequest(string reqStr, GraphNode root)
{
  Request req = parseRequest(reqStr);
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
  assert(false);
}

class NetsimRoot
{
}

class Netsim
{
  private NetsimRoot root;
}
*/

/*
Request parseRequest(string reqStr)
{
  import std.conv : to;
  import std.exception : enforce;
  import std.format : formattedRead;
  import std.string : capitalize, chomp, split, strip;

  reqStr = reqStr.chomp.strip;

  // TODO: verify with regex

  // Split line into RequestType and GraphPath
  string firstPart;
  string secondPart;
  reqStr.formattedRead!"%s %s"(firstPart, secondPart);
  firstPart = firstPart.strip;
  secondPart = secondPart.strip;

  enforce(firstPart.length > 0 && secondPart.length > 0, "Bad request");

  // Build request struct
  Request req;

  req.type = firstPart.capitalize.to!RequestType;
  req.path = parseGraphPath(secondPart);

  return req;
}

GraphPath parseGraphPath(string str)
{
  string[] calls;

  // a("aze)zae").a()

  {
    int callStartIndex = 0;
    bool withinString = false;
    bool withinChar = false;
    bool withinArgs = false;

    for (int i = 0; i < str.length; i++)
    {
      const char c = str[i];

      if (i + 1 == str.length)
      {
        enforce(c == ")" && withinArgs && !withinChar && !withinString,
          "parseGraphPath error: unterminated GraphPath string"
        );
      }

      // %s(%s)
      if (!withinArgs)
      {
        if (c == '(')
        {
          enforce(i > callStartIndex,
            format!"parseGraphPath error: missing method name for call with index %d"(calls.length)
          );
          withinArgs = true;
        }
      }
      else
      {
        // End of a GraphSegment
        if (c == ')' && !withinString && !withinChar)
        {
          calls ~= str[callStartIndex .. i + 1];

          if (i + 1 < str.length)
          {
            enforce(str[i + 1] == '.');
            callStartIndex = i + 2;
            withinArgs = withinChar = false;
          }
        }
        else if (c == '"')
          withinString = !withinString;
        else if (c == '\'')
          withinChar = !withinChar;
      }
    }
  }

  foreach (string call; calls)
  {
    string name;
    string argsStr;

    segmentStr.formattedRead!"%s(%s)"(name, argsStr);

    enforce(name.length > 0);
    enforce(name[0].isAlpha);
    enforce(name.all!isAlphaNum);
  }

  // // Ensure that the method name doesn't contain invalid characters
  // if (i == 0)
  //   enforce(c.isAlpha);
  // enforce(c.isAlphaNum);

  GraphPathSegment segment;

  segment.name = name;

  foreach (arg; argsStr.split(","))
    segment.args ~= arg;

  path.segments ~= segment;

  enforce(path.segments.length >= 1);

}
*/
