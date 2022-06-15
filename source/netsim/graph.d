module netsim.graph;

import painlessjson;

/*
  Todo: renaming, query has a lot of different meanings

  Query refers to:
    - One of the 2 types of requests
      - Keep
    - The function chain in each request
      -> ...FunctionChain consisting of ...Function's ? ...FunctionChainSegment's?
      -> CallChain?
      -> ...Path?
      -> GraphPath
    - indirectly to GraphNode
      -> ...ble
      -> GraphNode
*/

/*
  Rename
  add request mockup
  add request and GraphPath parsing
  add version(GenerateGraphSpec)
*/

// Full import needed
// (fixes error unknown identifier _d_toObject or rt_detachDisposeEvent)
public import std.signals;

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

Request parseRequest(string s)
{
  return Request();
}

///
// Graph nodes
///

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

/// Shared base template for resolveHelper and queryHelper
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

unittest
{
  // test resolveMixin
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
