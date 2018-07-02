import '../../general/Position.dart';
import '../Grid.dart';
import '../SearchHistory.dart';
import '../heuristics/Heuristic.dart';

abstract class Algorithm
{
   const Algorithm();

   SearchHistory searchP(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
   {
      return search(grid, grid[startPosition], grid[targetPosition], heuristic);
   }

   SearchHistory search(Grid grid, Node start, Node target, Heuristic heuristic);
}
