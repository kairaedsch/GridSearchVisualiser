import '../../../general/Position.dart';
import '../../../model/history/NodeSearchState.dart';
import '../../../model/history/SearchState.dart';
import 'package:quiver/core.dart';

class ExplanationNode
{
  final Optional<String> marking;
  final Optional<Position> parent;
  final Optional<String> info;
  final bool activeNodeInTurn;
  final bool markedOpenInTurn;
  final bool parentUpdated;

  ExplanationNode(SearchState searchState, Position position) :
        marking = new Optional.of(searchState[position].nodeMarking.name),
        parent = searchState[position].parent,
        activeNodeInTurn = searchState.activeNodeInTurn == position,
        markedOpenInTurn = searchState.markedOpenInTurn.contains(position),
        parentUpdated = searchState.parentUpdated.contains(position),
        info = searchState[position].info;

  const ExplanationNode.normal() :
        marking = const Optional.absent(),
        parent = const Optional.absent(),
        activeNodeInTurn = false,
        markedOpenInTurn = false,
        parentUpdated = false,
        info = const Optional.absent();
}