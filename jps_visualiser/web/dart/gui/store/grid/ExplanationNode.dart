import '../../../general/Position.dart';
import '../../../model/NodeSearchState.dart';
import 'package:quiver/core.dart';

class ExplanationNode
{
  final Optional<String> marking;
  final Optional<Position> parent;
  final Optional<String> info;
  final bool activeNodeInTurn;
  final bool markedOpenInTurn;
  final bool parentUpdated;

  ExplanationNode(NodeSearchState nodeSearchState, this.activeNodeInTurn) :
        marking = new Optional.of(nodeSearchState.nodeMarking.name),
        parent = nodeSearchState.parent,
        markedOpenInTurn = nodeSearchState.markedOpenInTurn,
        parentUpdated = nodeSearchState.parentUpdated,
        info = nodeSearchState.info;

  const ExplanationNode.normal() :
        marking = const Optional.absent(),
        parent = const Optional.absent(),
        activeNodeInTurn = false,
        markedOpenInTurn = false,
        parentUpdated = false,
        info = const Optional.absent();
}