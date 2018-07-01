import '../Grid.dart';
import '../SearchHistory.dart';
import '../heuristics/Heuristic.dart';

abstract class Algorithm
{
   SearchHistory search(Grid grid, Heuristic heuristic);
}