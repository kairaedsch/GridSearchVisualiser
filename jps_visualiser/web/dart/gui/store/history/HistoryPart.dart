import '../../../general/Array2D.dart';
import '../../../general/Position.dart';
import '../../../model/SearchState.dart';
import '../grid/ExplanationNode.dart';

class HistoryPart
{
  final Array2D<ExplanationNode> explanationNodes;
  final int id;
  final String title;
  final List<Position> path;

  HistoryPart(SearchState searchState)
      : id = searchState.id,
        title = searchState.title,
        explanationNodes = new Array2D(searchState, (p) => new ExplanationNode(searchState[p])),
        path = [new Position(0, 0), new Position(4, 6), new Position(2, 8)];
}