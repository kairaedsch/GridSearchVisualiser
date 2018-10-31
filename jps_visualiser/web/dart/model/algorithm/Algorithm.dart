import '../../general/geo/Position.dart';
import '../store/grid/GridCache.dart';
import '../history/SearchHistory.dart';
import '../heuristics/Heuristic.dart';

typedef AlgorithmFactory = Algorithm Function(GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory);

abstract class Algorithm
{
   final GridCache grid;
   final Position start, target;
   final Heuristic heuristic;
   final int _turnOfHistory;

   bool searched;

   final SearchHistory searchHistory;

   int nextTurn = 0;

   Algorithm(this.grid, this.start, this.target, this.heuristic, this._turnOfHistory)
       : searchHistory = new SearchHistory(grid.size)
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
