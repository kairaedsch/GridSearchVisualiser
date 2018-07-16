import '../../model/history/Highlight.dart';
import '../history/StoreHistory.dart';
import 'package:w_flux/w_flux.dart';

class StorePaths extends Store
{
  List<Highlight> _highlights;
  List<Highlight> get highlights => _highlights;

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
    _highlights = highlights;
    trigger();
  }
}

class ActionsPathsChanged
{

}
