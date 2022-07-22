module netsim.netsim;

import netsim.graph;
import netsim.project;
import netsim.apiserver;

import std.exception : enforce;
import std.format : format;
import std.uuid : UUID;

final class Netsim : GraphNode
{
  private Project[UUID] projects;
  private GraphApiServer apiServer;

  ///
  // Constructors / Destructor
  ///

  this()
  {
    apiServer = new GraphApiServer(this);
    apiServer.start;
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

  string handleRequest(Request req)
  {
    return "";
  }
}