import '../../general/Direction.dart';
import '../../general/Distance.dart';
import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'JumpPointSearchDataGenerator.dart';

class JumpPointSearch extends AStar
{
  static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new JumpPointSearch("JPS", grid, startPosition, targetPosition, heuristic);

  JumpPointSearchData _data;

  JumpPointSearch(String name, Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
      : super(name, grid, startPosition, targetPosition, heuristic);

  @override
  void runInner()
  {
    var dataGenerator = new JumpPointSearchDataGenerator(grid, start.position, target.position, heuristic);
    dataGenerator.run();
    _data = dataGenerator.data;

    super.runInner();
  }

  @override
  Iterable<Node> findNeighbourNodes(Node node)
  {
    Set<Direction> relevantDirections;
    if (node == start)
    {
      relevantDirections = new Set.from(Direction.values);
    }
    else
    {
      Direction lastDirection = parent[node].position.lastDirectionTo(node.position);
      var lastDirectionData = _data[node.position.go(lastDirection.turn(180))][lastDirection];
      relevantDirections = new Set.from(lastDirectionData.jumpDirections)..add(lastDirection);
    }

    List<Node> neighbours = [];

    Direction directionToTarget = node.position.firstDirectionTo(target.position);
    var directionToTargetData = _data[node.position][directionToTarget];
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

    for (Direction relevantDirection in relevantDirections)
    {
      var directionData = _data[node.position][relevantDirection];

      if (directionData.isJumpPointAhead)
      {
        neighbours.add(grid[node.position.goMulti(relevantDirection, directionData.distance)]);
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
