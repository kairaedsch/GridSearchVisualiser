import '../../../model/SearchHistory.dart';
import '../../../model/SearchState.dart';
import 'HistoryPart.dart';
import 'package:w_flux/w_flux.dart';

class StoreHistory extends Store
{
  List<HistoryPart> _storeHistoryParts;
  List<HistoryPart> get storeHistoryParts => _storeHistoryParts;

  HistoryPart _active;
  HistoryPart get active => _active;

  ActionsHistory _actions;
  ActionsHistory get actions => _actions;

  StoreHistory()
  {
    _storeHistoryParts = [];

    _actions = new ActionsHistory();
    _actions.historyChanged.listen(_historyChanged);
    _actions.activeChanged.listen(_activeChanged);
  }

  _historyChanged(SearchHistory searchHistory)
  {
    _storeHistoryParts = searchHistory.history.map((SearchState searchState) => new HistoryPart(searchState)).toList();
    _active = null;
    _actions.activeChanged.call(_storeHistoryParts[0]);
    trigger();
  }

  _activeChanged(HistoryPart newActive)
  {
    _active = newActive;
    trigger();
  }
}

class ActionsHistory
{
  final Action<SearchHistory> historyChanged = new Action<SearchHistory>();
  final Action<HistoryPart> activeChanged = new Action<HistoryPart>();
}
