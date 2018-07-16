import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../model/history/Explanation.dart';
import '../../model/history/Highlight.dart';
import '../../model/history/SearchState.dart';
import '../grid/ExplanationNode.dart';

class HistoryPart
{
  final Array2D<ExplanationNode> explanationNodes;
  final int turn;
  final Explanation title;
  final List<Explanation> description;
  final Position activeNodeInTurn;
  final List<Highlight> defaultHighlights;

  HistoryPart(SearchState searchState)
      : turn = searchState.turn,
        title = searchState.title,
        description = searchState.description,
        explanationNodes = new Array2D(searchState, (p) => new ExplanationNode(searchState, p)),
        activeNodeInTurn = searchState.activeNodeInTurn,
        defaultHighlights = searchState.defaultHighlights;
}