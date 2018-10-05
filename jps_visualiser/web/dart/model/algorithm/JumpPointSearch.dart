import '../../general/Direction.dart';
import '../../general/Distance.dart';
import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'JumpPointSearchJumpPoints.dart';
import 'JumpPointSearchPlusDataGenerator.dart';
import 'package:quiver/core.dart';
import 'package:tuple/tuple.dart';

class JumpPointSearch extends AStar
{
  static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new JumpPointSearch("JPS", grid, startPosition, targetPosition, heuristic);

  Map<Tuple2<Position, Direction>, JumpPointSearchDirectionAdviser> _directionAdvisers;

  JumpPointSearch(String name, Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
      : super(name, grid, startPosition, targetPosition, heuristic);

  @override
  void runInner()
  {
    _directionAdvisers = new Map();

    super.runInner();
  }

  @override
  Iterable<Node> findNeighbourNodes(Node node)
  {
    Iterable<Direction> relevantDirections;
    if (node == start)
    {
      relevantDirections = new Set.from(Direction.values);
    }
    else
    {
      var lastDirection = new Optional.of(parent[node].position.lastDirectionTo(node.position));
      var directionAdviser = _directionAdvisers[new Tuple2(node.position, lastDirection.value)];
      relevantDirections = new Set.from(directionAdviser.jumpDirections)..add(lastDirection.value);
    }

    List<Node> neighbours = [];

    for (Direction direction in relevantDirections)
    {
      var jumpPoint = getNextJumpPoint(node.position, direction);

      jumpPoint.ifPresent((p) => neighbours.add(grid[p]));
    }


    currentSearchState.description.add(new Explanation()
      ..addT("The explanation how JPS works is still missing.")
    );

    return neighbours;
  }

  Optional<Position> getNextJumpPoint(Position position, Direction direction)
  {
    if (!grid.leaveAble(position, direction))
    {
      return const Optional.absent();
    }
    else
    {
      Set<Direction> jumpDirections;
      var positionAfter = position.go(direction);
      if (positionAfter == target.position)
      {
        return new Optional.of(positionAfter);
      }
      if (direction.isCardinal)
      {
        jumpDirections = JumpPointSearchJumpPoints.cardinalJumpDirections(grid, positionAfter, direction);
      }
      else
      {
        jumpDirections = JumpPointSearchJumpPoints.diagonalJumpDirections(grid, positionAfter, direction, (position, direction) => getNextJumpPoint(position, direction).isNotEmpty);
      }
      if (jumpDirections.length > 0)
      {
        _directionAdvisers[new Tuple2(positionAfter, direction)] = new JumpPointSearchDirectionAdviser()..jumpDirections = jumpDirections;
        return new Optional.of(positionAfter);
      }
      else
      {
        return getNextJumpPoint(positionAfter, direction);
      }
    }
  }
}

class JumpPointSearchDirectionAdviser
{
  Set<Direction> jumpDirections = new Set();
}