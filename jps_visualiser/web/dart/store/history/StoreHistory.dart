import '../../model/history/Highlight.dart';
import '../../model/history/SearchHistory.dart';
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

  List<Highlight> _highlights;

  StoreHistory()
  {
    _history = const Optional.absent();
    _active = const Optional.absent();
    _highlights = [];

    _actions = new ActionsHistory();
    _actions.historyChanged.listen(_historyChanged);
    _actions.activeChanged.listen(_activeChanged);
    _actions.highlightsUpdate.listen(_highlightsUpdate);
    _actions.highlightsChanged.listen(_highlightsChanged);
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
    bool defaultHighlights = active.isEmpty || active.value.defaultHighlights == _highlights;
    _active = newActive;
    if (defaultHighlights || active.isEmpty)
    {
      _actions.highlightsUpdate.call([]);
    }
    trigger();
  }

  void _highlightsUpdate(List<Highlight> newHighlights)
  {
    if (active.isEmpty)
    {
      _actions.highlightsChanged.call([]);
    }
    else if (newHighlights.isEmpty && active.value.defaultHighlights.isNotEmpty)
    {
      _actions.highlightsChanged.call(active.value.defaultHighlights);
    }
    else
    {
      _actions.highlightsChanged.call(newHighlights);
    }
  }

  void _highlightsChanged(List<Highlight> newHighlights)
  {
    _highlights = newHighlights;
  }
}

class ActionsHistory
{
  final Action<SearchHistory> historyChanged = new Action<SearchHistory>();
  final Action<Optional<HistoryPart>> activeChanged = new Action<Optional<HistoryPart>>();
  final Action<List<Highlight>> highlightsUpdate = new Action<List<Highlight>>();
  final Action<List<Highlight>> highlightsChanged = new Action<List<Highlight>>();
}
