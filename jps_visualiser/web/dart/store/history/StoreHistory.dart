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
  List<Highlight> _customHighlights;

  StoreHistory()
  {
    _history = const Optional.absent();
    _active = const Optional.absent();
    _highlights = [];
    _customHighlights = [];

    _actions = new ActionsHistory();
    _actions.historyChanged.listen(_historyChanged);
    _actions.activeChanged.listen(_activeChanged);
    _actions.highlightsChanged.listen(_highlightsChanged);
    _actions.customHighlightsChanged.listen(_customHighlightsChanged);
  }

  void _historyChanged(SearchHistory searchHistory)
  {
    _history = new Optional.of(new History(searchHistory));

    Optional<HistoryPart> newActive = const Optional.absent();
    if (active.isPresent)
    {
      newActive = _history.value.parts
          .where((hp) => hp.turn == active.value.turn)
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

    _updateHighlights();
  }

  void _customHighlightsChanged(List<Highlight> newCustomHighlights)
  {
    _customHighlights = newCustomHighlights;
    _updateHighlights();
  }

  void _updateHighlights()
  {
    if (active.isEmpty)
    {
      _actions.highlightsChanged.call([]);
    }
    else if (_customHighlights.isEmpty)
    {
      _actions.highlightsChanged.call(new List.from(active.value.backgroundHighlights)..addAll(active.value.defaultHighlights));
    }
    else
    {
      _actions.highlightsChanged.call(new List.from(active.value.backgroundHighlights)..addAll(_customHighlights));
    }
  }

  void _highlightsChanged(List<Highlight> newHighlights)
  {
    _highlights = newHighlights;
  }
}

class ActionsHistory
{
  final Action<SearchHistory> historyChanged = new Action();
  final Action<Optional<HistoryPart>> activeChanged = new Action();
  final Action<List<Highlight>> highlightsChanged = new Action();
  final Action<List<Highlight>> customHighlightsChanged = new Action();
}
