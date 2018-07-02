import 'Grid.dart';
import 'SearchState.dart';

class SearchHistory
{
  List<Node> path;

  List<SearchState> _history;
  List<SearchState> get history => _history;


  SearchHistory()
  {
    _history = [];
  }

  void add(SearchState searchState)
  {
    _history.add(searchState);
  }
}