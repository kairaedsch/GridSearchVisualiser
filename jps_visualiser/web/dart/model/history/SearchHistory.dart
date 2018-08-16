import '../Grid.dart';
import 'SearchState.dart';
import 'dart:collection';
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

  int getTurnType(SearchState searchState)
  {
    int targetTypeId = searchState.getTypeId();
    Set<int> foundTargetIds = new HashSet();
    for (SearchState state in _history)
    {
      int typeId = state.getTypeId();
      if (targetTypeId == typeId)
      {
        return foundTargetIds.length;
      }
      foundTargetIds.add(typeId);
    }
    assert(false, "Did not found searchstate in history: ${searchState.turn}");
    return 0;
  }
}