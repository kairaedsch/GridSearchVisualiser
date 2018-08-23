import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../Grid.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';

class JumpPointSearchDataGenerator extends Algorithm
{
   static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new JumpPointSearchDataGenerator(grid, startPosition, targetPosition, heuristic);

   final JumpPointSearchData data;

   JumpPointSearchDataGenerator(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
       :  data = new JumpPointSearchData(),
          super(grid, startPosition, targetPosition, heuristic);

   @override
   void runInner()
   {

      searchHistory.title = "Generated JPS Data";
   }
}

class JumpPointSearchData
{
   Array2D<JumpPointSearchDataPoint> data;
}

class JumpPointSearchDataPoint
{
   JumpPointSearchDataPointType type;
   int distance;

   bool get isWall => type == JumpPointSearchDataPointType.WALL;
   bool get isJumpPoint => type == JumpPointSearchDataPointType.JUMP_POINT;
}

enum JumpPointSearchDataPointType
{
   WALL, JUMP_POINT
}