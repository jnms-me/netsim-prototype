# Netsim Prototype

## Notes

In vscode code-d settings, set serve-d version to nightly to prevent shortenedMethods errors.

## Requirements:

Client/Gui:
 - Can connect to a server, list its projects, and open a project
 - The project gui is a canvas with nodes and wires.
 - Can create / remove nodes and wire them up
 - Can open captures on any wire
 - Can open a shell on a docker container
 - Can manage a qemu vm via vnc or similar

Server:
 - 1 server application, capable of hosting multiple projects at once
 - 2 node types: docker and qemu, each with very limited configuration (eg interfaces preconfigured)
 - Can connect docker-docker, docker-qemu and qemu-qemu nodes

Extra: multiple clients can work on the same server (and maybe even project) simultaneously

## Implementation steps

Part 1:
- Spawning of docker containers and qemu vms from the server main
- Connecting them

Part 2:
- Client can connect to server, no projects, only 1 default 'project'
- Visualization in client with draggable nodes and static wires
- Manipulating the visualization: add/remove nodes, connect wires between predefined interfaces

Part 3:
- Add capture support to server
- Opening wireshark on client from any cable

Part 4:
- Manage containers and vms from within the client
