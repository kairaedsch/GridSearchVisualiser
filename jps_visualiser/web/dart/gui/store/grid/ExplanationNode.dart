import '../../../general/Position.dart';
import '../../../model/NodeSearchState.dart';
import 'package:quiver/core.dart';

class ExplanationNode
{
  final Optional<String> marking;
  final Optional<Position> parent;
  final Optional<String> info;
  final bool selectedNodeInTurn;
  final bool markedOpenInTurn;
  final bool parentUpdated;

  ExplanationNode(NodeSearchState nodeSearchState) :
        marking = new Optional.of(nodeSearchState.nodeMarking.name),
        parent = nodeSearchState.parent,
        selectedNodeInTurn = nodeSearchState.selectedNodeInTurn,
        markedOpenInTurn = nodeSearchState.markedOpenInTurn,
        parentUpdated = nodeSearchState.parentUpdated,
        info = nodeSearchState.info;

  ExplanationNode.normal() :
        marking = const Optional.absent(),
        parent = const Optional.absent(),
        selectedNodeInTurn = false,
        markedOpenInTurn = false,
        parentUpdated = false,
        info = const Optional.absent();
}