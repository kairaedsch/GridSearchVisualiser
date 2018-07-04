import '../../../general/Position.dart';
import '../../../model/NodeSearchState.dart';
import 'package:quiver/core.dart';

class ExplanationNode
{
  final Optional<String> marking;
  final Optional<Position> parent;
  final bool selectedNodeInTurn;

  ExplanationNode(NodeSearchState nodeSearchState) :
        marking = new Optional.of(nodeSearchState.nodeMarking.name),
        parent = nodeSearchState.parent,
        selectedNodeInTurn = nodeSearchState.selectedNodeInTurn;

  ExplanationNode.normal() :
        marking = const Optional.absent(),
        parent = const Optional.absent(),
        selectedNodeInTurn = false;
}