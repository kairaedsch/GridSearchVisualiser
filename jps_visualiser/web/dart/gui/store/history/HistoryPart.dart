import '../../../model/SearchState.dart';

class HistoryPart
{
  SearchState _searchState;
  SearchState get searchState => _searchState;

  int _id;
  int get id => _id;

  HistoryPart(this._searchState)
  {
    _id = _searchState.id;
  }
}