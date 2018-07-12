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

    Optional<HistoryPart> newActive = const Optional.absent();
    if (active.isPresent)
    {
      newActive = _history.value.parts
          .where((hp) => hp.activeNodeInTurn == active.value.activeNodeInTurn)
          .map((hp) => new Optional.of(hp))
          .firstWhere((hp) => true, orElse: () => const Optional.absent());
    }
    if (newActive.isEmpty && _history.value.parts.length > 0)
    {
      newActive = new Optional.of(_history.value.parts[0]);
    }
    _actions.activeChanged.call(newActive);
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
