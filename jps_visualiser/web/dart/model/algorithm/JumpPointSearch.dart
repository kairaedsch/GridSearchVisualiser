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
    Iterable<Direction> relevantDirections;
    if (node == start)
    {
      relevantDirections = Direction.values;
    }
    else
    {
      Direction lastDirection = parent[node].position.lastDirectionTo(node.position);
      relevantDirections = lastDirection.expand(lastDirection.isCardinal ? 2 : 1);
    }

    var neighbours = relevantDirections.map((relevantDirection)
    {
      var directionData = _data[node.position][relevantDirection];

      if (directionData.isJumpPointAhead || directionData.distance > 0)
      {
        Direction firstDirection = node.position.firstDirectionTo(target.position);
        if (firstDirection == relevantDirection)
        {
          var distanceToTarget = new Distance.calc(node.position, target.position);
          if (relevantDirection.isCardinal)
          {
            if (distanceToTarget.diagonal == 0)
            {
              if (distanceToTarget.cardinal <= directionData.distance)
              {
                return target;
              }
            }
          }
          else
          {
            if (distanceToTarget.diagonal != 0)
            {
              if (distanceToTarget.diagonal <= directionData.distance)
              {
                return grid[node.position.goMulti(relevantDirection, distanceToTarget.diagonal)];
              }
            }
          }
        }

        if (directionData.isJumpPointAhead)
        {
          return grid[node.position.goMulti(relevantDirection, directionData.distance)];
        }
        else
        {
          return null;
        }
      }
    }).where((n) => n != null).toList();

    currentSearchState.description.add(new Explanation()
      ..addT("This is not JPS. Please implement it. After we have choosen our active node, we will take a look at all of his ")
      ..addH("neighbour nodes", "blue", [new CircleHighlight(neighbours.map((n) => n.position).toSet())])
      ..addT(": ")
    );

    return neighbours;
  }
}
