import '../../general/geo/Distance.dart';
import '../../general/geo/Position.dart';
import '../history/Highlight.dart';
import '../store/grid/GridCache.dart';
import '../../general/geo/Direction.dart';
import '../history/Explanation.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'DirectedJumpPointSearchPreCalculator.dart';
import 'package:quiver/core.dart';
import 'package:tuple/tuple.dart';

class DirectedJumpPointSearchLookUp extends AStar
{
  static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new DirectedJumpPointSearchLookUp("DJPS Lookup with Pre-Calculation", grid, startPosition, targetPosition, heuristic, turnOfHistory);

  DirectedJumpPointSearchData _data;

  DirectedJumpPointSearchLookUp(String name, GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory)
      : super(name, grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {
    var dataGenerator = new DirectedJumpPointSearchPreCalculator(grid, start, target, heuristic, -1);
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

    var reachAble = canReachTarget(node, lastDirection);
    if (reachAble.isPresent)
    {
      neighbours.add(reachAble.value.item1);
      relevantDirections.remove(reachAble.value.item2);
    }

    for (Direction relevantDirection in relevantDirections)
    {
      DirectedJumpPointSearchDataSignpost directionData;
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
      List<Highlight> pathsOfRelevantDirections = relevantDirections
          .map((relevantDirection)
          {
            DirectedJumpPointSearchDataSignpost directionData = _data[node].signposts[relevantDirection];
            return new PathHighlight.styled(directionData.isJumpPointAhead ? "green" : "red" , [node, node.goMulti(relevantDirection, directionData.distance)], showEnd: true);
          }).toList();

      List<Highlight> newSignPosts = relevantDirections
          .where((relevantDirection) =>_data[node].signposts[relevantDirection].isJumpPointAhead)
          .expand((relevantDirection)
          {
            DirectedJumpPointSearchDataSignpost directionData = _data[node].signposts[relevantDirection];
            Position newNeighbourNode = node.goMulti(relevantDirection, directionData.distance);
            return visualiseDirectionAdviserDirect(newNeighbourNode, relevantDirection);
          }).toList();

      List<Highlight> openDirectionAdviser = open.where((o) => o != node).expand(visualiseDirectionAdviser).toList();

      searchHistory.addH_("foreground", pathsOfRelevantDirections, [null]);
      searchHistory.addH_("foreground", newSignPosts, [null]);
      searchHistory.addH_("foreground", openDirectionAdviser, [null]);
      searchHistory..newExplanation(new Explanation())
        ..addES_("<The DJPS Lookup Algorithm is working but the explanation for it has not been implemented yet>");
    }
    return neighbours.reversed;
  }

  Optional<Tuple2<Position, Direction>> canReachTarget(Position node, Optional<Direction> lastDirection)
  {
    if (node == target)
    {
      return new Optional.of(new Tuple2(target, lastDirection.value));
    }
    Direction directionToTarget = node.firstDirectionTo(target);
    if (lastDirection.isEmpty || directionToTarget != Directions.turn(lastDirection.value, 180))
    {
      var directionToTargetData = _data[node].signposts[directionToTarget];
      var distanceToTarget = new Distance.calc(node, target);
      if (Directions.isCardinal(directionToTarget))
      {
        if (distanceToTarget.cardinal <= directionToTargetData.distance)
        {
          return new Optional.of(new Tuple2(target, directionToTarget));
        }
      }
      else
      {
        if (distanceToTarget.diagonal <= directionToTargetData.distance)
        {
          Position intermediate = node.goMulti(directionToTarget, distanceToTarget.diagonal);
          if (canReachTarget(intermediate, new Optional.of(directionToTarget)).isNotEmpty)
          {
            return new Optional.of(new Tuple2(intermediate, directionToTarget));
          }
        }
      }
    }
    return const Optional.absent();
  }

  Iterable<PathHighlight> visualiseDirectionAdviser(Position node)
  {
    return parent[node] == null ? [] : visualiseDirectionAdviserDirect(node, parent[node].lastDirectionTo(node));
  }

  Iterable<PathHighlight> visualiseDirectionAdviserDirect(Position newNeighbourNode, Direction relevantDirection) {
     var newNeighbourNodeDirectionAdviser = _data[newNeighbourNode].directionAdvisers[relevantDirection];
    return newNeighbourNodeDirectionAdviser.jumpDirections.map((newNeighbourRelevantDirection)
    {
      return new PathHighlight.styled("green dotted", [newNeighbourNode, newNeighbourNode.go(newNeighbourRelevantDirection)], showEnd: true);
    });
  }
}
