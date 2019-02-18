import '../../general/geo/Distance.dart';
import '../../general/geo/Position.dart';
import '../heuristics/Octile.dart';
import '../history/Highlight.dart';
import '../store/grid/GridCache.dart';
import '../../general/geo/Direction.dart';
import '../history/Explanation.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'DirectedJumpPointSearchPreCalculator.dart';
import 'JumpPointSearchHighlights.dart';
import 'package:quiver/core.dart';
import 'package:tuple/tuple.dart';

class DirectedJumpPointSearchLookUp extends AStar
{
  static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new DirectedJumpPointSearchLookUp("DJPS Lookup", grid, startPosition, targetPosition, heuristic, turnOfHistory);

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

      if (createHistory())
      {
        searchHistory..newExplanation(new Explanation())
          ..addES_("In the first iteration, the DJPS Algorithm will search in ")
          ..addEMS("every direction", "green", DirectedJumpPointSearchHighlights.forcedDirections(node, relevantDirections), null)
          ..addES_(". ");
      }
    }
    else
    {
      lastDirection = new Optional.of(parent[node].lastDirectionTo(node));
      var directionAdviser = _data[node].directionAdvisers[lastDirection.value];
      relevantDirections = new Set.from(directionAdviser.jumpDirections)..add(lastDirection.value);

      if (createHistory())
      {
        List<Highlight> parentPath = [new PathHighlight.styled("yellow", [parent[node], node], showEnd: true)];
        searchHistory..newExplanation(new Explanation())
          ..addES_("The DJPS Algorithm will search in every ")
          ..addEMS("relevant direction", "green", DirectedJumpPointSearchHighlights.forcedDirections(node, relevantDirections), null)
          ..addES_(", which includes ")
          ..addEMS("all forced directions", "green", parentPath.toList()..addAll(DirectedJumpPointSearchHighlights.forcedDirections(node, directionAdviser.jumpDirections)), null)
          ..addES_(" of the current selected node in the direction from its parent to it and the ")
          ..addEMS("direction from its parent", "green", parentPath.toList()..addAll(DirectedJumpPointSearchHighlights.forcedDirections(node, [lastDirection.value])), null)
          ..addES_(". Note: The forced directions do not have to be calculated but are looked up. ");
      }
    }

    List<Position> neighbours = [];

    if (createHistory())
    {
      searchHistory..newExplanation(new Explanation())
        ..addES_("Before we start exploring every relevant direction, we try to reach the target node via the ")
        ..addESS("octile path", "green", new PathHighlight(new Octile().getPath(node, target), showEnd: true), null)
        ..addES_(" from the current selected node to it. ");
    }

    var reachAble = canReachTarget(node, lastDirection);
    if (reachAble.isPresent)
    {
      if (createHistory())
      {
        searchHistory
          ..addES_("Because the octile path is valid, we have found our ")
          ..addESS("first neighbour", "blue", new CircleHighlight(), reachAble.value.item1)
          ..addES_(". ");
        if (relevantDirections.contains(reachAble.value.item2))
        {
          searchHistory.addES_("Note: We will not jump into the ${Directions.getName(reachAble.value.item2)} direction, because we already did so and reached to the target node.");
        }
      }
      neighbours.add(reachAble.value.item1);
      relevantDirections.remove(reachAble.value.item2);
    }
    else if (createHistory())
    {
      searchHistory
        ..addES_("But the octile path is blocked.");
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
      List<Highlight> pathsOfRelevantDirectionsSuccess = relevantDirections
          .where((relevantDirection) => _data[node].signposts[relevantDirection].isJumpPointAhead)
          .map((relevantDirection)
          {
            DirectedJumpPointSearchDataSignpost directionData = _data[node].signposts[relevantDirection];
            return new PathHighlight.styled("green", [node, node.goMulti(relevantDirection, directionData.distance)], showEnd: true);
          }).toList();
      List<Highlight> pathsOfRelevantDirectionsFail = relevantDirections
          .where((relevantDirection) => !_data[node].signposts[relevantDirection].isJumpPointAhead)
          .map((relevantDirection)
          {
            DirectedJumpPointSearchDataSignpost directionData = _data[node].signposts[relevantDirection];
            return new PathHighlight.styled("red" , [node, node.goMulti(relevantDirection, directionData.distance)], showEnd: true);
          }).toList();

      List<Highlight> openDirectionAdviser = open.where((o) => o != node).expand(visualiseDirectionAdviser).toList();

      searchHistory.addH_("foreground", pathsOfRelevantDirectionsSuccess.toList()..addAll(pathsOfRelevantDirectionsFail), [null]);
      searchHistory.addH_("foreground", openDirectionAdviser, [null]);

      searchHistory..newExplanation(new Explanation())
        ..addES_("Using the lookup data, we check each relevant direction. ");

      if (pathsOfRelevantDirectionsFail.isNotEmpty)
      {
        String __s = pathsOfRelevantDirectionsFail.length == 1 ? "" : "s";
        String was_were = pathsOfRelevantDirectionsFail.length == 1 ? "was" : "were";

        searchHistory
          ..addES_("There $was_were no next jump point$__s pre-calculated for ")
          ..addEMS("${pathsOfRelevantDirectionsFail.length} direction$__s", "red", pathsOfRelevantDirectionsFail, null)
          ..addES_(". Hence we found no neighbour for this direction$__s. ");
      }

      if (pathsOfRelevantDirectionsSuccess.isNotEmpty)
      {
        String __s = pathsOfRelevantDirectionsSuccess.length == 1 ? "" : "s";
        String was_were = pathsOfRelevantDirectionsSuccess.length == 1 ? "was" : "were";
        String a__ = pathsOfRelevantDirectionsSuccess.length == 1 ? "a " : "";

        searchHistory
          ..addES_("For ")
          ..addEMS("${pathsOfRelevantDirectionsSuccess.length} direction$__s", "green", pathsOfRelevantDirectionsSuccess, null)
          ..addES_(" there $was_were pre-calculated ${a__}next jump point$__s. We therefore found here ${pathsOfRelevantDirectionsSuccess.length} neighbour$__s")
          ..addES_(". ");
      }

      String __s = neighbours.length == 1 ? "" : "s";

      searchHistory..newExplanation(new Explanation())
        ..addES_("In total, we found ")
        ..addESM("${neighbours.length} neighbour$__s", "blue", new CircleHighlight(), neighbours)
        ..addES_(". We now check each one of them: ");
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
