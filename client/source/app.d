import std.stdio;

import std.functional : toDelegate;

import gtk.Main;
import gtk.Builder;
import gtk.Window;
import gtk.Widget;

import gtk.TreeView;
import gtk.ListStore;
import gtk.TreeIter;

import gtk.TreePath;
import gtk.TreeViewColumn;

T getObjectSafe(T)(Builder b, string name)
{
  T ret = cast(T) b.getObject(name);
  assert(ret !is null);
  return ret;
}

void main(string[] args)
{
  Main.init(args);

  Builder b = new Builder();
  b.addFromFile("ui.glade");

  Window w = b.getObjectSafe!Window("main-window");
  w.addOnHide((Widget aux) { Main.quit; });

  TreeView nodeList = b.getObjectSafe!TreeView("node-list");
  NodeStore nodeStore = new NodeStore();
  nodeList.setModel(nodeStore);
  nodeStore.fetch();
  nodeList.addOnRowActivated(toDelegate(&handleNodeListRowActivated));

  w.showAll;
  Main.run;
}

void handleNodeListRowActivated(TreePath path, TreeViewColumn col, TreeView tree)
{
  import gtk.TreeModelIF;

  TreeModelIF model = tree.getModel;
  TreeIter iter = new TreeIter();
  model.getIter(iter, path);
  assert(iter !is null);
  string col0 = model.getValueString(iter, 0);

  writeln("Row activated: ", col0);
}

class NodeStore : ListStore
{
  this()
  {
    super([GType.STRING]);
  }

  void fetch()
  {
    import vibe.http.client;
    import vibe.data.json;

    try
    {
      // dfmt off
      requestHTTP("http://localhost:8080/nodes",
        (scope req) {},
        (scope res) {
          Json json = res.readJson;

          // Verify json
          assert(json.type == Json.Type.object);
          assert("data" in json);
          assert(json["data"].type == Json.Type.array);
          foreach (Json node; json["data"])
            assert(node.type == Json.Type.string);

          // Create rows
          clear();
          TreeIter iter = new TreeIter;
          foreach (Json node; json["data"])
          {
            append(iter);
            setValue(iter, 0, node.get!string);
          }
        }
      );
      // dfmt on
    }
    catch (Exception e)
    {
      writeln(e);
    }
  }
}
