import '../../../general/Array2D.dart';
import '../../../general/Position.dart';
import '../../../model/SearchState.dart';
import '../grid/ExplanationNode.dart';

class HistoryPart
{
  final Array2D<ExplanationNode> explanationNodes;
  final int turn;
  final String title;
  final List<Position> path;
  final Position activeNodeInTurn;

  HistoryPart(SearchState searchState)
      : turn = searchState.turn,
        title = searchState.title,
        explanationNodes = new Array2D(searchState, (p) => new ExplanationNode(searchState[p], p == searchState.activeNodeInTurn)),
        path = [new Position(0, 0), new Position(4, 6), new Position(2, 8)],
        activeNodeInTurn = searchState.activeNodeInTurn;
}