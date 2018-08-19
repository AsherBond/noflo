#     NoFlo - Flow-Based Programming for JavaScript
#     (c) 2013-2018 Flowhub UG
#     (c) 2011-2012 Henri Bergius, Nemein
#     NoFlo may be freely distributed under the MIT license
BaseNetwork = require './BaseNetwork'

# ## The NoFlo network coordinator
#
# NoFlo networks consist of processes connected to each other
# via sockets attached from outports to inports.
#
# The role of the network coordinator is to take a graph and
# instantiate all the necessary processes from the designated
# components, attach sockets between them, and handle the sending
# of Initial Information Packets.
class Network extends BaseNetwork
  # All NoFlo networks are instantiated with a graph. Upon instantiation
  # they will load all the needed components, instantiate them, and
  # set up the defined connections and IIPs.
  constructor: (graph, options = {}) ->
    super graph, options

  # Add a process to the network. The node will also be registered
  # with the current graph.
  addNode: (node, callback) ->
    super node, (err, process) =>
      return callback err if err
      @graph.addNode node.id, node.component, node.metadata
      callback null, process

  # Remove a process from the network. The node will also be removed
  # from the current graph.
  removeNode: (node, callback) ->
    super node, (err) =>
      return callback err if err
      @graph.removeNode node.id
      callback()

  # Rename a process in the network. Renaming a process also modifies
  # the current graph.
  renameNode: (oldId, newId, callback) ->
    super oldId, newId, (err) =>
      return callback err if err
      @graph.renameNode oldId, newId
      callback()

  # Add a connection to the network. The edge will also be registered
  # with the current graph.
  addEdge: (edge, callback) ->
    super edge, (err) =>
      return callback err if err
      @graph.addEdgeIndex edge.from.node, edge.from.port, edge.from.index, edge.to.node, edge.to.port, edge.to.index, edge.metadata
      callback()

  # Remove a connection from the network. The edge will also be removed
  # from the current graph.
  removeEdge: (edge, callback) ->
    super edge, (err) =>
      return callback err if err
      @graph.removeEdge edge.from.node, edge.from.port, edge.to.node, edge.to.port
      callback()

  # Add an IIP to the network. The IIP will also be registered with the
  # current graph. If the network is running, the IIP will be sent immediately.
  addInitial: (iip, callback) ->
    super iip, (err) =>
      return callback err if err
      @graph.addInitialIndex iip.from.data, iip.to.node, iip.to.port, iip.to.index, iip.metadata
      callback()

  # Remove an IIP from the network. The IIP will also be removed from the
  # current graph.
  removeInitial: (iip, callback) ->
    super iip, (err) =>
      return callback err if err
      @graph.removeInitial iip.to.node, iip.to.port
      callback()

exports.Network = Network
