import '../general/Size.dart';
import '../model/history/SearchHistory.dart';
import '../model/algorithm/Algorithm.dart';
import '../model/heuristics/Heuristic.dart';
import 'StoreAlgorithmSettings.dart';
import 'grid/StorePaths.dart';
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

  StorePaths _storePaths;
  StorePaths get storePaths => _storePaths;

  ActionsMain _actions;
  ActionsMain get actions => _actions;

  StoreMain(Size size)
  {
    _storeHistory = new StoreHistory();
    _storeGridSettings = new StoreGridSettings(size);
    _storeAlgorithmSettings = new StoreAlgorithmSettings();
    _storeGrid = new StoreGrid(_storeGridSettings, _storeHistory.actions);
    _storePaths = new StorePaths(_storeHistory.actions);

    _actions = new ActionsMain();
    _actions.runAlgorithm.listen((Object _) => _runAlgorithm());
  }

  void _runAlgorithm()
  {
    Heuristic heuristic = storeAlgorithmSettings.heuristicType.heuristic;
    Algorithm algorithm = storeAlgorithmSettings.algorithmType.algorithmFactory(storeGrid.gridBarrierManager.toGrid(), storeGrid.sourcePosition, storeGrid.targetPosition, heuristic);

    SearchHistory searchHistory = algorithm.search();

    storeHistory.actions.historyChanged.call(searchHistory);
  }
}

class ActionsMain
{
  final Action runAlgorithm = new Action<Object>();
}
