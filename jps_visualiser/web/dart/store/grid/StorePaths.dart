import '../../model/history/Highlight.dart';
import '../history/StoreHistory.dart';
import 'package:w_flux/w_flux.dart';

class StorePaths extends Store
{
  List<PathHighlight> _highlights;
  List<PathHighlight> get highlights => _highlights;

  ActionsPathsChanged _actions;
  ActionsPathsChanged get actions => _actions;

  StorePaths(ActionsHistory actionsHistory)
  {
    _highlights = [];

    _actions = new ActionsPathsChanged();

    actionsHistory.highlightsChanged.listen(_historyHighlightsChanged);
  }

  void _historyHighlightsChanged(List<Highlight> highlights)
  {
    _highlights = highlights.where((h) => h is PathHighlight).map((h) => h as PathHighlight).toList();
    trigger();
  }
}

class ActionsPathsChanged
{

}
