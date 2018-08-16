import '../../model/history/SearchHistory.dart';
import '../../model/history/SearchState.dart';
import 'HistoryPart.dart';

class History
{
  final List<HistoryPart> parts;
  final String title;

  History(SearchHistory searchHistory)
      : parts = searchHistory.history.map((SearchState searchState) => new HistoryPart(searchState, searchHistory.getTurnType(searchState))).toList(growable: false),
        title = searchHistory.title;
}