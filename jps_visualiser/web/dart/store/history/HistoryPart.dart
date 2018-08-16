import '../../model/history/Explanation.dart';
import '../../model/history/Highlight.dart';
import '../../model/history/SearchState.dart';

class HistoryPart
{
  final int turn;
  final int turnType;
  final Explanation title;
  final List<Explanation> description;
  final List<Highlight> defaultHighlights;
  final List<Highlight> backgroundHighlights;

  HistoryPart(SearchState searchState, this.turnType)
      : turn = searchState.turn,
        title = searchState.title,
        description = searchState.description,
        defaultHighlights = searchState.defaultHighlights,
        backgroundHighlights = searchState.backgroundHighlights;
}