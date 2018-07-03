import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/SearchHistory.dart';
import '../../model/algorithm/Algorithm.dart';
import '../../model/heuristics/Heuristic.dart';
import 'grid/ExplanationNode.dart';
import 'StoreAlgorithmSettings.dart';
import 'grid/StoreGrid.dart';
import 'StoreGridSettings.dart';
import 'grid/StructureNode.dart';
import 'history/StoreHistory.dart';
import 'package:w_flux/w_flux.dart';

class StoreMain extends Store
{
  StoreGridSettings _storeGridSettings;
  StoreGridSettings get storeGridSettings => _storeGridSettings;

  StoreAlgorithmSettings _storeAlgorithmSettings;
  StoreAlgorithmSettings get storeAlgorithmSettings => _storeAlgorithmSettings;

  StoreGrid _storeGrid;
  StoreGrid get storeGrid => _storeGrid;

  StoreHistory _storeHistory;
  StoreHistory get storeHistory => _storeHistory;

  ActionsMain _actions;
  ActionsMain get actions => _actions;

  StoreMain(Size size)
  {
    _storeHistory = new StoreHistory();
    _storeGridSettings = new StoreGridSettings(size);
    _storeAlgorithmSettings = new StoreAlgorithmSettings();
    _storeGrid = new StoreGrid(storeGridSettings, _storeHistory.actions);

    _actions = new ActionsMain();
    _actions.runAlgorithm.listen((_) => _runAlgorithm());
  }

  void _runAlgorithm()
  {
    Algorithm algorithm = storeAlgorithmSettings.algorithmType.algorithm;
    Heuristic heuristic = storeAlgorithmSettings.heuristicType.heuristic;

    SearchHistory searchHistory = algorithm.searchP(storeGrid.toGrid(storeGridSettings.allowDiagonal.value, storeGridSettings.crossCorners.value), storeGrid.sourcePosition, storeGrid.targetPosition, heuristic);

    storeHistory.actions.historyChanged.call(searchHistory);
  }
}

class ActionsMain
{
  final Action runAlgorithm = new Action();
}
