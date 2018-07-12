import '../../../general/Array2D.dart';
import '../../../general/Position.dart';
import '../../../model/SearchHistory.dart';
import '../../../model/SearchState.dart';
import '../grid/ExplanationNode.dart';
import 'HistoryPart.dart';

class History
{
  final List<HistoryPart> parts;
  final String title;

  History(SearchHistory searchHistory)
      : parts = searchHistory.history.map((SearchState searchState) => new HistoryPart(searchState)).toList(growable: false),
        title = searchHistory.title;
}