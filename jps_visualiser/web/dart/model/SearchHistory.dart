import 'Grid.dart';
import 'SearchState.dart';
import 'package:quiver/core.dart';

class SearchHistory
{
  Optional<List<Node>> _path;
  Optional<List<Node>> get path => _path;

  List<SearchState> _history;
  List<SearchState> get history => _history;

  String title;

  SearchHistory()
  {
    _history = [];
    _path = const Optional.absent();
  }

  void setPath(List<Node> newPath)
  {
    _path = new Optional.of(newPath);
  }

  void add(SearchState searchState)
  {
    _history.add(searchState);
  }
}