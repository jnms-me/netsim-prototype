module netsim.core.netsim;

import netsim.core.project;
import netsim.graph.apiserver;
import netsim.graph.graph;

import std.concurrency : spawn, Tid;
import std.exception : enforce;
import std.format : format;
import std.uuid : UUID;

final class Netsim : GraphNode
{
  private Project[UUID] projects;
  private Tid apiServerThread;

  ///
  // Constructors / Destructor
  ///

  this()
  {
    apiServerThread = spawn(&graphApiServerLoop);
  }

  ///
  // Accessing projects
  ///

  Project[UUID] getProjects()
  {
    return projects;
  }

  bool projectExists(UUID id)
  {
    return (id in projects) !is null;
  }

  Project getProject(UUID id)
  {
    Project* project = id in projects;
    enforce(projects !is null, format!"getProject failed: project with id %s does not exist"(id));
    return *project;
  }

  UUID[] listProjectIds()
  {
    return projects.keys;
  }

  ///
  // Implementing GraphNode
  ///

  mixin resolveMixin!(getProject);
  mixin emptyQueryMixin;

  ///
  // For GraphApiServer
  ///

  void listenForGraphApiRequests()
  {
    while (true)
    {
      // receive
      // Request req;
      // string result = handleRequest(req, this);
      // send
    }
  }
}
