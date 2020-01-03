import '../general/general/Util.dart';
import '../general/geo/Position.dart';
import '../general/transfer/TransferSlave.dart';
import 'algorithm/Dijkstra.dart';
import 'algorithm/AStar.dart';
import 'algorithm/Algorithm.dart';
import 'algorithm/JumpPointSearch.dart';
import 'algorithm/JumpPointSearchPlus.dart';
import 'algorithm/JumpPointSearchPlusDataGenerator.dart';
import 'algorithm/NoAlgorithm.dart';
import 'heuristics/Chebyshev.dart';
import 'heuristics/Euclidean.dart';
import 'heuristics/Heuristic.dart';
import 'heuristics/Manhattan.dart';
import 'heuristics/Octile.dart';
import 'history/Highlight.dart';
import 'dart:async';
import 'dart:isolate';
import 'store/Enums.dart';
import 'store/Store.dart';

void main(List<String> args, SendPort sendPort)
{
  new PathfinderWorker.isolate(sendPort);
}

class PathfinderWorker
{
  Store _store = new Store();
  Timer _timerToRun = new Timer(new Duration(days: 1), () => null);

  PathfinderWorker.isolate(SendPort sendPort)
  {
    Util.print('Worker created');

    new TransferSlave(sendPort, _store);
    _setup();
  }

  PathfinderWorker.noIsolate(Store other_store)
  {
    other_store.transferListener = (Iterable<String> ids) => ids.forEach((id) => _store.set(id, other_store.getA<dynamic>(id), toTransfer: false));
    _store.transferListener = (Iterable<String> ids) => ids.forEach((id) => other_store.set(id, _store.getA<dynamic>(id), toTransfer: false));

    _setup();
  }

  void _setup()
  {
    _store.addStartsWithListener(["size", "barrier_", "startPosition", "targetPosition", "algorithmType", "heuristicType", "gridMode", "directionMode", "cornerMode", "directionalMode", "currentStepId", "currentStepDescriptionHoverId"], (ids)
    {
      _timerToRun.cancel();
      _timerToRun = new Timer(new Duration(milliseconds: 1), _run);
    });
    _run();
  }

  void _run()
  {
    _store.autoTriggerListeners = false;
    _runInner(_store.currentStepId);
    _store.autoTriggerListeners = true;
    _store.triggerListeners();
  }

  void _runInner(int currentStepId)
  {
    Util.print("run: $currentStepId");
    DateTime start = new DateTime.now();

    Position startPosition = _store.startPosition;
    Position targetPosition = _store.targetPosition;

    Heuristic heuristic;
    switch(_store.heuristicType)
    {
      case HeuristicType.CHEBYSHEV: heuristic = new Chebyshev(); break;
      case HeuristicType.EUCLIDEAN: heuristic = new Euclidean(); break;
      case HeuristicType.MANHATTEN: heuristic = new Manhattan(); break;
      case HeuristicType.OCTILE: heuristic = new Octile(); break;
    }
    
    AlgorithmFactory algorithmFactory;
    switch(_store.algorithmType)
    {
      case AlgorithmType.NO_ALGORITHM: algorithmFactory = NoAlgorithm.factory; break;
      case AlgorithmType.DIJKSTRA: algorithmFactory = Dijkstra.factory; break;
      case AlgorithmType.A_STAR: algorithmFactory = AStar.factory; break;
      case AlgorithmType.JPS: algorithmFactory = JumpPointSearch.factory; break;
      case AlgorithmType.JPSP: algorithmFactory = JumpPointSearchPlus.factory; break;
      case AlgorithmType.JPSP_DATA: algorithmFactory = JumpPointSearchPlusDataGenerator.factory; break;
    }

    Algorithm algorithm = algorithmFactory(_store.gridCache, startPosition, targetPosition, heuristic, currentStepId);

    DateTime beforeRun = new DateTime.now();
    algorithm.run();
    DateTime afterRun = new DateTime.now();

    bool wasLastStep = currentStepId == _store.stepCount - 1;
    bool isLastStep = currentStepId == algorithm.searchHistory.stepCount - 1;
    if ((wasLastStep && !isLastStep) || currentStepId >= algorithm.searchHistory.stepCount)
    {
      _runInner(algorithm.searchHistory.stepCount - 1);
      return;
    }

    _store.title = algorithm.searchHistory.title;
    _store.stepCount = algorithm.searchHistory.stepCount;
    _store.currentStepId = currentStepId;
    _store.currentStepTitle = algorithm.searchHistory.stepTitle;
    _store.currentStepDescription = algorithm.searchHistory.stepDescription;
    List<Highlight> backgroundPathHighlights = Util.notNull(algorithm.searchHistory.stepHighlights[null]["background"], orElse: () => []);
    List<Highlight> foregroundPathHighlights = Util.notNull(algorithm.searchHistory.stepHighlights[null][_store.currentStepDescriptionHoverId], orElse: () => []);
    _store.setCurrentStepHighlights(null, new List.from(backgroundPathHighlights)..addAll(foregroundPathHighlights));

    for (Position position in _store.size.positions())
    {
      List<Highlight> backgroundHighlights = Util.notNull(algorithm.searchHistory.stepHighlights[position]["background"], orElse: () => []);
      List<Highlight> foregroundHighlights = Util.notNull(algorithm.searchHistory.stepHighlights[position][_store.currentStepDescriptionHoverId], orElse: () => []);
      _store.setCurrentStepHighlights(position, new List.from(backgroundHighlights)..addAll(foregroundHighlights));
    }
    DateTime afterStore = new DateTime.now();

    Util.print("setup: ${beforeRun.difference(start).inMilliseconds}ms");
    Util.print("run  : ${afterRun.difference(beforeRun).inMilliseconds}ms");
    Util.print("store: ${afterStore.difference(afterRun).inMilliseconds}ms");
  }
}