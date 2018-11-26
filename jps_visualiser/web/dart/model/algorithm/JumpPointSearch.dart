import '../../general/geo/Position.dart';
import '../store/grid/GridCache.dart';
import '../../general/geo/Direction.dart';
import '../history/Explanation.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'JumpPointSearchJumpPoints.dart';
import 'package:quiver/core.dart';
import 'package:tuple/tuple.dart';

class JumpPointSearch extends AStar
{
  static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new JumpPointSearch("JPS", grid, startPosition, targetPosition, heuristic, turnOfHistory);

  JumpPointSearch(String name, GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory)
      : super(name, grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {
    super.runInner();
  }

  @override
  Iterable<Position> findNeighbourNodes(Position node)
  {
    Iterable<Direction> relevantDirections;
    if (node == start)
    {
      relevantDirections = new Set.from(Direction.values);
    }
    else
    {
      var lastDirection = parent[node].lastDirectionTo(node);
      Set<Direction> jumpDirections = JumpPointSearchJumpPoints.jumpDirections(grid, node, lastDirection, (position, direction) => getNextJumpPoint(position, direction).isNotEmpty);
      relevantDirections = new Set.from(jumpDirections)..add(lastDirection);
    }

    List<Position> neighbours = [];

    for (Direction direction in relevantDirections)
    {
      var jumpPoint = getNextJumpPoint(node, direction);

      jumpPoint.ifPresent((p) => neighbours.add(p));
    }

    if (createHistory())
    {
      searchHistory..newExplanation(new Explanation())
        ..addES_("<The JPS Algorithm is working but the explanation for it has not been implemented yet>");
    }
    return neighbours;
  }

  Optional<Position> getNextJumpPoint(Position node, Direction direction)
  {
    if (!grid.leaveAble(node, direction))
    {
      return const Optional.absent();
    }
    else
    {
      var positionAfter = node.go(direction);
      if (positionAfter == target)
      {
        return new Optional.of(positionAfter);
      }
      Set<Direction> jumpDirections = JumpPointSearchJumpPoints.jumpDirections(grid, positionAfter, direction, (position, direction) => getNextJumpPoint(position, direction).isNotEmpty);

      if (jumpDirections.length > 0)
      {
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
