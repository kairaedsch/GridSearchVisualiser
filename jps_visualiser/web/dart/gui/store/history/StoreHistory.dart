import '../../../model/SearchHistory.dart';
import '../../../model/SearchState.dart';
import 'History.dart';
import 'HistoryPart.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreHistory extends Store
{
  Optional<History> _history;
  Optional<History> get history => _history;

  Optional<HistoryPart> _active;
  Optional<HistoryPart> get active => _active;

  ActionsHistory _actions;
  ActionsHistory get actions => _actions;

  StoreHistory()
  {
    _history = const Optional.absent();
    _active = const Optional.absent();

    _actions = new ActionsHistory();
    _actions.historyChanged.listen(_historyChanged);
    _actions.activeChanged.listen(_activeChanged);
  }

  void _historyChanged(SearchHistory searchHistory)
  {
    _history = new Optional.of(new History(searchHistory));

    HistoryPart newActive = null;
    if (active.isPresent)
    {
      newActive = _history.value.parts
          .where((hp) => hp.activeNodeInTurn == active.value.activeNodeInTurn)
          .first;
    }
    if (newActive == null)
    {
      newActive = _history.value.parts[0];
    }
    _actions.activeChanged.call(new Optional.of(newActive));
    trigger();
  }

  void _activeChanged(Optional<HistoryPart> newActive)
  {
    _active = newActive;
    trigger();
  }
}

class ActionsHistory
{
  final Action<SearchHistory> historyChanged = new Action<SearchHistory>();
  final Action<Optional<HistoryPart>> activeChanged = new Action<Optional<HistoryPart>>();
}
