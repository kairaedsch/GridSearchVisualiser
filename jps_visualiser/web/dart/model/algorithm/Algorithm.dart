import '../../general/Position.dart';
import '../Grid.dart';
import '../history/SearchHistory.dart';
import '../heuristics/Heuristic.dart';
import '../history/SearchState.dart';

typedef AlgorithmFactory = Algorithm Function(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic);

abstract class Algorithm
{
   final Grid grid;
   final Node start, target;
   final Heuristic heuristic;

   bool searched;

   final SearchHistory searchHistory;

   SearchState _currentSearchState;
   SearchState get currentSearchState => _currentSearchState;

   int nextTurn = 0;

   Algorithm(this.grid, Position startPosition, Position targetPosition, this.heuristic)
       : start = grid[startPosition],
         target = grid[targetPosition],
         searchHistory = new SearchHistory()
   {
      searched = false;
   }

   void addSearchState()
   {
     _currentSearchState = new SearchState(nextTurn);
     searchHistory.add(_currentSearchState);
     nextTurn++;
   }

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
