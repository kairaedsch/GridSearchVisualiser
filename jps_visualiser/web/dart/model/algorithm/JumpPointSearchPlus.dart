import '../../general/geo/Distance.dart';
import '../../general/geo/Position.dart';
import '../store/GridCache.dart';
import '../grid/Direction.dart';
import '../history/Explanation.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'JumpPointSearchPlusDataGenerator.dart';
import 'package:quiver/core.dart';

class JumpPointSearchPlus extends AStar
{
  static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new JumpPointSearchPlus("JPS+", grid, startPosition, targetPosition, heuristic, turnOfHistory);

  JumpPointSearchData _data;

  JumpPointSearchPlus(String name, GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory)
      : super(name, grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {
    var dataGenerator = new JumpPointSearchPlusDataGenerator(grid, start, target, heuristic, -1);
    dataGenerator.run();
    _data = dataGenerator.data;

    super.runInner();
  }

  @override
  Iterable<Position> findNeighbourNodes(Position node)
  {
    Optional<Direction> lastDirection;
    Set<Direction> relevantDirections;
    if (node == start)
    {
      lastDirection = new Optional.absent();
      relevantDirections = new Set.from(Direction.values);
    }
    else
    {
      lastDirection = new Optional.of(parent[node].lastDirectionTo(node));
      var directionAdviser = _data[node].directionAdvisers[lastDirection.value];
      relevantDirections = new Set.from(directionAdviser.jumpDirections)..add(lastDirection.value);
    }

    List<Position> neighbours = [];

    Direction directionToTarget = node.firstDirectionTo(target);
    if (lastDirection.isEmpty || directionToTarget != Directions.turn(lastDirection.value, 180))
    {
      var directionToTargetData = _data[node].signposts[directionToTarget];
      var distanceToTarget = new Distance.calc(node, target);
      if (Directions.isCardinal(directionToTarget))
      {
        if (distanceToTarget.cardinal <= directionToTargetData.distance)
        {
          neighbours.add(target);
          relevantDirections.remove(directionToTarget);
        }
      }
      else
      {
        if (distanceToTarget.diagonal <= directionToTargetData.distance)
        {
          neighbours.add(node.goMulti(directionToTarget, distanceToTarget.diagonal));
          relevantDirections.remove(directionToTarget);
        }
      }
    }

    for (Direction relevantDirection in relevantDirections)
    {
      JumpPointSearchDataSignpost directionData;
      Position position = node;

      do
      {
        directionData = _data[position].signposts[relevantDirection];
        position = position.goMulti(relevantDirection, directionData.distance);
      }
      while (directionData.isIntermediateJumpPointAhead);

      if (directionData.isJumpPointAhead)
      {
        neighbours.add(position);
      }
    }

    if (createHistory())
    {
      searchHistory..newExplanation(new Explanation())
        ..addES_("<The JPS Algorithm is working but the explanation for it has not been implemented yet>");
    }
    return neighbours;
  }
}
