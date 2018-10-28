import '../../general/Position.dart';
import '../../model/Grid.dart';
import '../../model/algorithm/Dijkstra.dart';
import '../../model/algorithm/AStar.dart';
import '../../model/algorithm/Algorithm.dart';
import '../../model/algorithm/JumpPointSearch.dart';
import '../../model/algorithm/JumpPointSearchPlus.dart';
import '../../model/algorithm/JumpPointSearchPlusDataGenerator.dart';
import '../../model/heuristics/Chebyshev.dart';
import '../../model/heuristics/Euclidean.dart';
import '../../model/heuristics/Heuristic.dart';
import '../../model/heuristics/Manhattan.dart';
import '../../model/heuristics/Octile.dart';
import '../../model/history/Highlight.dart';
import '../general/TransferSlave.dart';
import '../transfer/Data.dart';
import '../transfer/GridSettings.dart';

void main()
{
  new PathfinderWorker(null);
}

class PathfinderWorker
{
  Data _data;

  PathfinderWorker(this._data)
  {
    if (_data == null)
    {
      print('Worker created');

      _data = new Data();
      new TransferSlave(_data);
    }

    _data.addListener(["size", "barrier_", "startPosition", "targetPosition", "algorithmType", "heuristicType", "gridMode", "directionMode", "cornerMode", "directionalMode", "currentStepId"], (String id, dynamic oldValue, dynamic newValue)
    {
      _run(_data);
    });
  }

  void _run(Data data)
  {
    Grid grid = new Grid(data.size, (p) => new Node(p, (d) => data.gridBarrierManager.leaveAble(p, d)));

    Position startPosition = data.startPosition;
    Position targetPosition = data.targetPosition;

    Heuristic heuristic;
    switch(data.heuristicType)
    {
      case HeuristicType.CHEBYSHEV: heuristic = new Chebyshev(); break;
      case HeuristicType.EUCLIDEAN: heuristic = new Euclidean(); break;
      case HeuristicType.MANHATTEN: heuristic = new Manhattan(); break;
      case HeuristicType.OCTILE: heuristic = new Octile(); break;
    }
    
    AlgorithmFactory algorithmFactory;
    switch(data.algorithmType)
    {
      case AlgorithmType.DIJKSTRA: algorithmFactory = Dijkstra.factory; break;
      case AlgorithmType.A_STAR: algorithmFactory = AStar.factory; break;
      case AlgorithmType.JPS: algorithmFactory = JumpPointSearch.factory; break;
      case AlgorithmType.JPSP: algorithmFactory = JumpPointSearchPlus.factory; break;
      case AlgorithmType.JPSP_DATA: algorithmFactory = JumpPointSearchPlusDataGenerator.factory; break;
    }

    Algorithm algorithm = algorithmFactory(grid, startPosition, targetPosition, heuristic, _data.currentStepId);

    algorithm.run();

    bool wasLastStep = data.currentStepId == data.stepCount - 1;
    bool isLastStep = data.currentStepId == algorithm.searchHistory.stepCount - 1;
    if ((wasLastStep && !isLastStep) || data.currentStepId >= algorithm.searchHistory.stepCount)
    {
      data.currentStepId = algorithm.searchHistory.stepCount - 1;
      return;
    }

    _data.title = algorithm.searchHistory.title;
    _data.stepCount = algorithm.searchHistory.stepCount;
    _data.currentStepTitle = algorithm.searchHistory.stepTitle;
    _data.currentStepDescription = algorithm.searchHistory.stepDescription;

    for (Position position in _data.size.positions())
    {
      var currentStepHighlights = _data.getCurrentStepHighlights(position);
      var newStepHighlights = algorithm.searchHistory.stepHighlights[position];
      if (!_equal(currentStepHighlights, newStepHighlights))
      {
        _data.setCurrentStepHighlights(position, newStepHighlights);
      }
    }
    _data.setCurrentStepHighlights(null, algorithm.searchHistory.stepHighlights[null]);
  }

  bool _equal(Map<String, List<Highlight>> mapOne, Map<String, List<Highlight>> mapTwo)
  {
    if (mapOne.length != mapTwo.length)
    {
      return false;
    }
    for (String key in mapOne.keys)
    {
      List<Highlight> listOne = mapOne[key];
      List<Highlight> listTwo = mapTwo[key];
      if (listOne == null || listTwo == null || listOne.length != listTwo.length)
      {
        return false;
      }
      for (int i = 0; i < listOne.length; i++)
      {
        if (listOne[i] != listTwo[i])
        {
          return false;
        }
      }
    }
    return true;
  }
}