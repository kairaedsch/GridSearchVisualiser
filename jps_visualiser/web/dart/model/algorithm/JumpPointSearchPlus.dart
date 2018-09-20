import '../../general/Direction.dart';
import '../../general/Distance.dart';
import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'JumpPointSearchPlusDataGenerator.dart';
import 'package:quiver/core.dart';

class JumpPointSearchPlus extends AStar
{
  static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new JumpPointSearchPlus("JPS+", grid, startPosition, targetPosition, heuristic);

  JumpPointSearchData _data;

  JumpPointSearchPlus(String name, Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
      : super(name, grid, startPosition, targetPosition, heuristic);

  @override
  void runInner()
  {
    var dataGenerator = new JumpPointSearchPlusDataGenerator(grid, start.position, target.position, heuristic);
    dataGenerator.run();
    _data = dataGenerator.data;

    super.runInner();
  }

  @override
  Iterable<Node> findNeighbourNodes(Node node)
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
      lastDirection = new Optional.of(parent[node].position.lastDirectionTo(node.position));
      var directionAdviser = _data[node.position].directionAdvisers[lastDirection.value];
      relevantDirections = new Set.from(directionAdviser.jumpDirections)..add(lastDirection.value);
    }

    List<Node> neighbours = [];

    Direction directionToTarget = node.position.firstDirectionTo(target.position);
    if (lastDirection.isEmpty || directionToTarget != lastDirection.value.turn(180))
    {
      var directionToTargetData = _data[node.position].signposts[directionToTarget];
      var distanceToTarget = new Distance.calc(node.position, target.position);
      if (directionToTarget.isCardinal)
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
          neighbours.add(grid[node.position.goMulti(directionToTarget, distanceToTarget.diagonal)]);
          relevantDirections.remove(directionToTarget);
        }
      }
    }

    for (Direction relevantDirection in relevantDirections)
    {
      JumpPointSearchDataSignpost directionData;
      Position position = node.position;

      do
      {
        directionData = _data[position].signposts[relevantDirection];
        position = position.goMulti(relevantDirection, directionData.distance);
      }
      while (directionData.isIntermediateJumpPointAhead);

      if (directionData.isJumpPointAhead)
      {
        neighbours.add(grid[position]);
      }
    }

    currentSearchState.description.add(new Explanation()
      ..addT("This is not JPS. Please implement it. After we have choosen our active node, we will take a look at all of his ")
      ..addH("neighbour nodes", "blue", [new CircleHighlight(neighbours.map((n) => n.position).toSet())])
      ..addT(": ")
    );

    return neighbours;
  }
}
