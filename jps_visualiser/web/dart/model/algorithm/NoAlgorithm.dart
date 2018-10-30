import '../../general/Position.dart';
import '../Grid.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';

class NoAlgorithm extends Algorithm
{
   static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new NoAlgorithm(grid, startPosition, targetPosition, heuristic, turnOfHistory);

   NoAlgorithm(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) : super(grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {

  }
}
