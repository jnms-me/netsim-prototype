module netsim.query;

import painlessjson;

// Todo: renaming, query has a lot of different meanings

// Full import needed for the module to link, as it only contains a template
// (fixes error unknown identifier _d_toObject or rt_detachDisposeEvent)
public import std.signals;

///
// The parsed query structure
///

/// A Query is the part after the "query" or "subscribe" in a request, parsed into a struct.
struct Query
{
  QuerySegment[] segments;
}

/** 
 * A method call with arguments.
 * If the segment is the last one in a Query this can also be a signal (with no arguments).
 */
struct QuerySegment
{
  QuerySegmentType type;
  /// Method or signal name
  string name;
  /// Only used if type is Method
  string[] args;
}

enum QuerySegmentType : ubyte
{
  Method,
  Signal
}

interface Queryable
{
  /** 
   * Calls the method referred to by `segment` and returns its result: a QueryAble child.
   * Params:
   *   segment = Any but the last segment of a Query, with type = Method.
   * Returns: The Queryable child on which the next segement should be called upon.
   */
  Queryable resolve(QuerySegment segment);

  /** 
   * Calls the method referred to by `segment` and returns its result: a string.
   * Params:
   *   segment = The last segment of a Query, with type = Method.
   * Returns: The result of the method referred to by `segment`, that should be sent to the client.
   */
  string query(QuerySegment segment);

  /** 
   * Every time the signal referred to by `segment` is triggered, calls hook with the value of that signal.
   * Calling this multiple times with the same hook will result in that hook also being called multiple times when the
   * signal triggers.
   * Params:
   *   segment = The last segment of a Query, with type = Signal.
   *   hook = A delegate referring to a class method with signature "void method(string)".
   */
  void subscribe(QuerySegment segment, void delegate(string) hook);

  /**
   * Removes a hook from the call list of the signal referred to by `segment`.
   * If a hook was added multiple times with multiple `subscribe` calls, all those subscriptions will be undone.
   * Params:
   *   segment = The last segment of a Query, with type = Signal.
   *   hook = A delegate referring to a class method with signature "void method(string)".
   */
  void unsubscribe(QuerySegment segment, void delegate(string) hook);
}

///
// Mixins for easily the Queryable interface in a class
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
  import netsim.query : Queryable, QuerySegment, ResolveOrQueryEnum;
  import painlessjson : toJSON;
  import std.algorithm : map;
  import std.conv : to;
  import std.exception : enforce;
  import std.format : format;
  import std.range : iota, join;
  import std.traits : arity, Parameters;

  auto base(QuerySegment segment)
  {
    switch (segment.name)
    {
      static foreach (Method; Methods)
      {
        const string MethodName = __traits(identifier, Method);
        alias MethodArgCount = arity!Method;
        alias MethodArgTypes = Parameters!Method;

    case MethodName:
        enforce(segment.args.length == MethodArgCount, format!"Method %s expected %d arguments instead of %d"(
            MethodName, MethodArgCount, segment.args.length
        ));

        // Convert string arguments to the type expected by the method
        static foreach (i, Type; MethodArgTypes)
        {
          mixin(format!"Type arg_%d = void;"(i));
          try
          {
            mixin(format!"arg_%d = segment.args[%d].to!Type;"(i, i));
          }
          catch (Exception e)
          {
            throw new Exception(format!"Failed to convert string \"%s\" to type %s: %s"(segment.args[i], Type.stringof,
                e.message));
          }
        }

        // Generate argument list string (arg_0,arg_1,...)
        const string argsToMixin = iota(MethodArgCount).map!(i => format!"arg_%d"(i)).join(",");

        static if (ResolveOrQuery == ResolveOrQueryEnum.Resolve)
          mixin(format!"return cast(Queryable) %s(%s);"(MethodName, argsToMixin));
        else static if (ResolveOrQuery == ResolveOrQueryEnum.Query)
          mixin(format!"return %s(%s).toJSON;"(MethodName, argsToMixin));
        else
          static assert(false);
      }

    default:
      assert(false, format!"Invalid method name %s"(segment.name));
    }
  }
}

/** 
 * When mixed into a class, this template provides a `resolve` method as in the Queryable interface.
 * Params:
 *   Methods: List of final methods of the current Queryable class that return a Queryable child.
 */
template resolveMixin(Methods...)
{
  import netsim.query : Queryable, QuerySegment;

  Queryable resolve(QuerySegment segment)
  in (segment.type == QuerySegmentType.Method)
  {
    import netsim.query : baseResolveQueryMixin, ResolveOrQueryEnum;
    import std.traits : isFinalFunction, ReturnType;

    static foreach (Method; Methods)
    {
      static assert(isFinalFunction!Method);
      static assert(__traits(compiles, {
          ReturnType!Method a;
          Queryable b = cast(Queryable) a;
        }));
    }

    mixin baseResolveQueryMixin!(ResolveOrQueryEnum.Resolve, Methods);
    return base(segment);
  }
}

/** 
 * When mixed into a class, this template provides a `query` method as in the Queryable interface.
 * Params:
 *   Methods: List of final methods of the current Queryable class that return a string (usually json).
 */
template queryMixin(Methods...)
{
  import netsim.query : QuerySegment;

  string query(QuerySegment segment)
  in (segment.type == QuerySegmentType.Method)
  {
    import std.traits : isFinalFunction, ReturnType;
    import netsim.query : baseResolveQueryMixin, ResolveOrQueryEnum;
    import painlessjson : toJSON;

    static foreach (Method; Methods)
    {
      static assert(isFinalFunction!Method);
      static assert(__traits(compiles, {
          ReturnType!Method a;
          string b = a.toJson;
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
    Queryable foo(int a, string b)
    {
      assert(a == 1 && b == "str");
      success = true;
      return null;
    }

    mixin resolveMixin!foo;
  }

  A a = new A;

  QuerySegment segment;
  segment.type = QuerySegmentType.Method;
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
