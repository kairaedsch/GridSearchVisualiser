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

    _data.addListener((String id)
    {
      _run(_data);
    });
  }

  void _run(Data data)
  {
    Grid grid = new Grid(data.size, null);

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

    Algorithm algorithm = algorithmFactory(grid, startPosition, targetPosition, heuristic);

    algorithm.run();

    _data.searchHistory = algorithm.searchHistory;
  }
}