import '../../general/Position.dart';
import '../Grid.dart';
import '../history/SearchHistory.dart';
import '../heuristics/Heuristic.dart';

typedef AlgorithmFactory = Algorithm Function(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory);

abstract class Algorithm
{
   final Grid grid;
   final Node start, target;
   final Heuristic heuristic;
   final int _turnOfHistory;

   bool searched;

   final SearchHistory searchHistory;

   int nextTurn = 0;

   Algorithm(this.grid, Position startPosition, Position targetPosition, this.heuristic, this._turnOfHistory)
       : start = grid[startPosition],
         target = grid[targetPosition],
         searchHistory = new SearchHistory(grid)
   {
      searched = false;
   }

   void tunIsOver()
   {
     nextTurn++;
   }

   bool createHistory() => nextTurn - 1 == _turnOfHistory;

   void run()
   {
      if (!searched)
      {
         searched = true;
         runInner();
      }
      else
      {
         throw new Exception("Already run");
      }
   }

   void runInner();
}
