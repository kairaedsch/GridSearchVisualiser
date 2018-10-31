import '../../general/geo/Position.dart';
import '../store/grid/GridCache.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';

class NoAlgorithm extends Algorithm
{
   static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new NoAlgorithm(grid, startPosition, targetPosition, heuristic, turnOfHistory);

   NoAlgorithm(GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) : super(grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {

  }
}
