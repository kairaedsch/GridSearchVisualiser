import '../../general/geo/Position.dart';
import '../history/Highlight.dart';
import '../store/grid/GridCache.dart';
import '../../general/geo/Direction.dart';
import '../history/Explanation.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';
import 'JumpPointSearchHighlights.dart';
import 'JumpPointSearchJumpPoints.dart';
import 'package:quiver/core.dart';
import 'package:tuple/tuple.dart';

class DirectedJumpPointSearch extends AStar
{
  static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new DirectedJumpPointSearch("DJPS", grid, startPosition, targetPosition, heuristic, turnOfHistory);

  DirectedJumpPointSearch(String name, GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory)
      : super(name, grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {
    super.runInner();
  }

  List<Tuple2<Iterable<Highlight>, Iterable<Position>>> nextJumpPointHighlights = [];

  @override
  Iterable<Position> findNeighbourNodes(Position node)
  {
    Iterable<Direction> relevantDirections;
    if (node == start)
    {
      relevantDirections = new Set.from(Direction.values);

      if (createHistory())
      {
        searchHistory..newExplanation(new Explanation())
          ..addES_("In the first iteration, the DJPS Algorithm will search in ")
          ..addEMS("every direction", "green", DirectedJumpPointSearchHighlights.forcedDirections(node, relevantDirections), null)
          ..addES_(":");
      }
    }
    else
    {
      var lastDirection = parent[node].lastDirectionTo(node);
      Set<Direction> jumpDirections = DirectedJumpPointSearchJumpPoints.jumpDirections(grid, node, lastDirection, (position, direction) => getNextJumpPoint(position, direction).isNotEmpty, false);
      relevantDirections = new Set.from(jumpDirections)..add(lastDirection);

      if (createHistory())
      {
        List<Highlight> parentPath = [new PathHighlight.styled("yellow", [parent[node], node], showEnd: true)];
        searchHistory..newExplanation(new Explanation())
          ..addES_("The DJPS Algorithm will search in every ")
          ..addEMS("relevant direction", "green", DirectedJumpPointSearchHighlights.forcedDirections(node, relevantDirections), null)
          ..addES_(", which includes ")
          ..addEMS("all forced directions", "green", parentPath.toList()..addAll(DirectedJumpPointSearchHighlights.forcedDirections(node, jumpDirections)), null)
          ..addES_(" of the current selected node in the direction from its parent to it and the ")
          ..addEMS("direction from its parent", "green", parentPath.toList()..addAll(DirectedJumpPointSearchHighlights.forcedDirections(node, [lastDirection])), null)
          ..addES_(":");
      }

    }
    List<Position> neighbours = [];

    nextJumpPointHighlights.clear();
    var allNextJumpPointHighlights = nextJumpPointHighlights.toList();

    for (Direction direction in relevantDirections)
    {
      var jumpPoint = getNextJumpPoint(node, direction);

      jumpPoint.ifPresent((p) => neighbours.add(p));

      if (createHistory())
      {
        nextJumpPointHighlights.add(new Tuple2([new DotHighlight.styled("blue")], jumpPoint));
        searchHistory..newExplanation(new Explanation())
          ..addES_(" - We ")
          ..addEM_("search", jumpPoint.isPresent ? "green" : "red", nextJumpPointHighlights.toList())
          ..addES_(" in to the ${Directions.getName(direction)} direction and find ");
        if (jumpPoint.isEmpty)
        {
          searchHistory.addES_("no jump point");
        }
        else
        {
          searchHistory.addESS("a jump point", "blue", new CircleHighlight(), jumpPoint.value);
        }
        searchHistory.addES_(".");
      }

      allNextJumpPointHighlights.addAll(nextJumpPointHighlights);
      nextJumpPointHighlights.clear();
    }

    if (createHistory())
    {
      searchHistory..newExplanation(new Explanation())
        ..addES_("So ")
        ..addEM_("totally", "green", allNextJumpPointHighlights)
        ..addES_(" we found ")
        ..addESM("${neighbours.length} neighbour${neighbours.length == 1 ? "" : "s"}", "blue", new CircleHighlight(), neighbours)
        ..addES_(":");
    }

    return neighbours;
  }

  Optional<Position> getNextJumpPoint(Position node, Direction direction) {
    if (!grid.leaveAble(node, direction))
    {
      //nextJumpPointHighlights.add(new Tuple2([new DotHighlight.styled("red")], [node]));
      return const Optional.absent();
    }
    else
    {
      Optional<Position> result;

      var positionAfter = node.go(direction);
      if (positionAfter == target)
      {
        result = new Optional.of(positionAfter);
      }
      else
      {
        Set<Direction> jumpDirections = DirectedJumpPointSearchJumpPoints.jumpDirections(
          grid, positionAfter, direction, (position,
          direction) => getNextJumpPoint(position, direction).isNotEmpty, false);

        if (jumpDirections.length > 0)
        {
          result = new Optional.of(positionAfter);
          if (createHistory())
          {
            nextJumpPointHighlights.add(new Tuple2(DirectedJumpPointSearchHighlights.forcedDirections(positionAfter, jumpDirections), [null]));
          }
        }
        else
        {
          result = getNextJumpPoint(positionAfter, direction);
        }
      }

      if (createHistory())
      {
        nextJumpPointHighlights.add(new Tuple2(DirectedJumpPointSearchHighlights.recursiveStep(node, direction, result.isPresent), [null]));
      }

      return result;
    }
  }
}

class JumpPointSearchDirectionAdviser
{
  Set<Direction> jumpDirections = new Set();
}
