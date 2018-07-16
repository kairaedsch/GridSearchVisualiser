import 'package:quiver/core.dart';

class NodeSearchState
{
  NodeMarking nodeMarking;
  Optional<String> _info;
  Optional<String> get info => _info;

  NodeSearchState() :
        nodeMarking = NodeMarking.UNMARKED_NODE,
        _info = const Optional.absent();

  void addInfo(String newInfo) => _info = new Optional.of((_info.isPresent ? _info.value + " " : "") + newInfo);
}

class NodeMarking
{
  static const NodeMarking UNMARKED_NODE = const NodeMarking("UNMARKED_NODE");
  static const NodeMarking MARKED_OPEN_NODE = const NodeMarking("MARKED_OPEN_NODE");
  static const NodeMarking MARKED_CLOSED_NODE = const NodeMarking("MARKED_CLOSED_NODE");

  final String name;

  String toString() => name;

  const NodeMarking(this.name);

  static const List<NodeMarking> values = const <NodeMarking>[
    UNMARKED_NODE, MARKED_OPEN_NODE, MARKED_CLOSED_NODE];
}