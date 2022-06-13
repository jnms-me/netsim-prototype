module netsim.query;

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
