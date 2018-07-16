import '../../general/Position.dart';
import '../../model/history/SearchState.dart';
import 'package:quiver/core.dart';

class ExplanationNode
{
  final Optional<String> marking;
  final Optional<String> info;
  final bool activeNodeInTurn;

  ExplanationNode(SearchState searchState, Position position) :
        marking = new Optional.of(searchState[position].nodeMarking.name),
        activeNodeInTurn = searchState.activeNodeInTurn == position,
        info = searchState[position].info;

  const ExplanationNode.normal() :
        marking = const Optional.absent(),
        activeNodeInTurn = false,
        info = const Optional.absent();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExplanationNode &&
              runtimeType == other.runtimeType &&
              marking == other.marking &&
              info == other.info &&
              activeNodeInTurn == other.activeNodeInTurn;

  @override
  int get hashCode =>
      marking.hashCode ^
      info.hashCode ^
      activeNodeInTurn.hashCode;
}