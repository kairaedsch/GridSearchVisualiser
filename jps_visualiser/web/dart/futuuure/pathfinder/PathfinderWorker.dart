import '../../general/Position.dart';
import '../../model/Grid.dart';
import '../../model/algorithm/Dijkstra.dart';
import '../../model/algorithm/AStar.dart';
import '../../model/algorithm/Algorithm.dart';
import '../../model/algorithm/JumpPointSearch.dart';
import '../../model/algorithm/JumpPointSearchPlus.dart';
import '../../model/algorithm/JumpPointSearchPlusDataGenerator.dart';
import '../../model/algorithm/NoAlgorithm.dart';
import '../../model/heuristics/Chebyshev.dart';
import '../../model/heuristics/Euclidean.dart';
import '../../model/heuristics/Heuristic.dart';
import '../../model/heuristics/Manhattan.dart';
import '../../model/heuristics/Octile.dart';
import '../general/TransferSlave.dart';
import '../transfer/Data.dart';
import '../transfer/GridSettings.dart';
import 'dart:async';
import 'dart:isolate';

void main(List<String> args, SendPort sendPort)
{
  new PathfinderWorker.isolate(sendPort);
}

class PathfinderWorker
{
  Data _data;
  Timer _timerToRun = new Timer(new Duration(days: 1), () => null);

  PathfinderWorker.isolate(SendPort sendPort)
  {
    print('Worker created');

    _data = new Data();
    new TransferSlave(sendPort, _data);
    _setup();
  }

  PathfinderWorker.noIsolate(this._data)
  {
    _setup();
  }

  void _setup()
  {
    _data.addSimpleListener(["size", "barrier_", "startPosition", "targetPosition", "algorithmType", "heuristicType", "gridMode", "directionMode", "cornerMode", "directionalMode", "currentStepId", "currentStepDescriptionHoverId"], ()
    {
      _timerToRun.cancel();
      _timerToRun = new Timer(new Duration(milliseconds: 1), _run);
    });
  }

  void _run()
  {
    _data.autoTriggerListeners = false;
    _runInner(_data.currentStepId);
    _data.autoTriggerListeners = true;
    _data.triggerListeners();
  }

  void _runInner(int currentStepId)
  {
    Grid grid = new Grid(_data.size, (p) => new Node(p, (d) => _data.gridBarrierManager.leaveAble(p, d)));

    Position startPosition = _data.startPosition;
    Position targetPosition = _data.targetPosition;

    Heuristic heuristic;
    switch(_data.heuristicType)
    {
      case HeuristicType.CHEBYSHEV: heuristic = new Chebyshev(); break;
      case HeuristicType.EUCLIDEAN: heuristic = new Euclidean(); break;
      case HeuristicType.MANHATTEN: heuristic = new Manhattan(); break;
      case HeuristicType.OCTILE: heuristic = new Octile(); break;
    }
    
    AlgorithmFactory algorithmFactory;
    switch(_data.algorithmType)
    {
      case AlgorithmType.NO_ALGORITHM: algorithmFactory = NoAlgorithm.factory; break;
      case AlgorithmType.DIJKSTRA: algorithmFactory = Dijkstra.factory; break;
      case AlgorithmType.A_STAR: algorithmFactory = AStar.factory; break;
      case AlgorithmType.JPS: algorithmFactory = JumpPointSearch.factory; break;
      case AlgorithmType.JPSP: algorithmFactory = JumpPointSearchPlus.factory; break;
      case AlgorithmType.JPSP_DATA: algorithmFactory = JumpPointSearchPlusDataGenerator.factory; break;
    }

    Algorithm algorithm = algorithmFactory(grid, startPosition, targetPosition, heuristic, currentStepId);

    algorithm.run();

    bool wasLastStep = currentStepId == _data.stepCount - 1;
    bool isLastStep = currentStepId == algorithm.searchHistory.stepCount - 1;
    if ((wasLastStep && !isLastStep) || currentStepId >= algorithm.searchHistory.stepCount)
    {
      _runInner(algorithm.searchHistory.stepCount - 1);
      return;
    }

    _data.title = algorithm.searchHistory.title;
    _data.stepCount = algorithm.searchHistory.stepCount;
    _data.currentStepId = currentStepId;
    _data.currentStepTitle = algorithm.searchHistory.stepTitle;
    _data.currentStepDescription = algorithm.searchHistory.stepDescription;
    _data.setCurrentStepHighlights(null, algorithm.searchHistory.stepHighlights[null]);

    for (Position position in _data.size.positions())
    {
      var newStepHighlights = algorithm.searchHistory.stepHighlights[position];
      _data.setCurrentStepHighlights(position, newStepHighlights);
    }

  }
}