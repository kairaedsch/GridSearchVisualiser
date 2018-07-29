import '../../general/Position.dart';
import '../Grid.dart';
import '../history/SearchHistory.dart';
import '../heuristics/Heuristic.dart';

typedef AlgorithmFactory = Algorithm Function(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic);

abstract class Algorithm
{
   Grid grid;
   Node start, target;
   Heuristic heuristic;

   bool searched;

   Algorithm(this.grid, Position startPosition, Position targetPosition, this.heuristic)
   {
      start = grid[startPosition];
      target = grid[targetPosition];
      searched = false;
   }

   SearchHistory search()
   {
      if (!searched)
      {
         searched = true;
         return searchInner();
      }
      else
      {
         throw new Exception("Already searched");
      }
   }

   SearchHistory searchInner();
}
