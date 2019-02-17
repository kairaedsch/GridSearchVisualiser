import '../../general/geo/Distance.dart';
import '../../general/geo/Position.dart';
import '../store/grid/GridCache.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';
import 'Dijkstra.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';

abstract class BasicSearchAlgorithm extends Algorithm
{
  final String name;

  Map<Position, Distance> distance;
  Map<Position, Position> parent;

  Set<Position> open;
  Set<Position> closed;

  BasicSearchAlgorithm(this.name, GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) : super(grid, startPosition, targetPosition, heuristic, turnOfHistory)
  {
    distance = new Map<Position, Distance>();
    parent = new Map<Position, Position>();
    open = new LinkedHashSet();
    closed = new Set();
  }

  Position findNextActiveNode();

  Iterable<Position> findNeighbourNodes(Position position);

  Distance getDistance(Position n)
  {
    return distance.containsKey(n) ? distance[n] : Distance.INFINITY;
  }

  List<Position> getPath(Position n)
  {
    if (parent[n] == null)
    {
      return [];
    }
    List<Position> path = [];
    {
      path.add(n);
      Position intermediateNode = n;
      while (intermediateNode != start)
      {
        intermediateNode = parent[intermediateNode];
        path.add(intermediateNode);
      }
      path = path.reversed.toList();
    }
    return path;
  }

  @override
  void runInner()
  {
    tunIsOver();

    distance[start] = new Distance(0, 0);
    open.add(start);
    
    if (createHistory())
    {
      searchHistory.stepTitle = "Setup";

      searchHistory..newExplanation(new Explanation())
        ..addES_("For the setup we: ");

      searchHistory..newExplanation(new Explanation.styled("enumeration"))
        ..addES_("Set all nodes unmarked.");

      searchHistory..newExplanation(new Explanation.styled("enumeration"))
        ..addES_("Set the distance from our ")
        ..addESS("start node", "green", new CircleHighlight(), start)
        ..addES_(" to our ")
        ..addESS("start node", "green", new CircleHighlight(), start)
        ..addES_(" to 0.0.");

      searchHistory..newExplanation(new Explanation.styled("enumeration"))
        ..addES_("Mark our ")
        ..addESS("start node open", "green", new BoxHighlight(), start)
        ..addES_(".");
    }

    int turn;
    for (turn = 1; open.isNotEmpty; turn++)
    {
      tunIsOver();

      if (createHistory())
      {
        searchHistory.stepTitle = "Iteration $turn";
      }
      Position nStar = findNextActiveNode();

      if (createHistory())
      {
        searchHistory.addH_("background", [new BoxHighlight.styled("green")], open);
        searchHistory.addH_("background", [new BoxHighlight.styled("grey")], closed);
      }

      Set<Position> updatedNodes = new Set();

      if (nStar == target)
      {
        if (createHistory())
        {
          var optimalPath = new PathHighlight.styled("blue blinking", getPath(target).toList(), showEnd: true);
          searchHistory..newExplanation(new Explanation())
            ..addES_("As our current selected node is our ")
            ..addESS("target node", "red", new CircleHighlight(), target)
            ..addES_(", the algorithm can finish and we have found an ")
            ..addESS("optimal path", "blue", optimalPath, null)
            ..addES_(" from the ")
            ..addESS("source node", "green", new CircleHighlight(), start)
            ..addES_(" to the ")
            ..addESS("target node", "red", new CircleHighlight(), target)
            ..addES_(".");

          searchHistory.addH_("foreground", [optimalPath], [null]);
          searchHistory.addH_("foreground", [new DotHighlight.styled("yellow")], [nStar]);
        }
        searchHistory.foundPath = true;
        break;
      }
      else
      {
        var neighbours = findNeighbourNodes(nStar);
        var neighboursMarkedClosed = neighbours.where((n) => closed.contains(n)).toList();
        var neighboursMarkedOpen = neighbours.where((n) => open.contains(n)).toList();
        var neighboursUnmarked = neighbours.where((n) => !closed.contains(n) && !open.contains(n)).toList();

        if (neighboursMarkedClosed.isNotEmpty)
        {
          if (createHistory())
          {
            List<PathHighlight> pathsOfClosed = neighboursMarkedClosed.map((on) => new PathHighlight(getPath(on).toList(), showEnd: true)).toList();

            String __s = neighboursMarkedClosed.length == 1 ? "" : "s";
            String is_are = neighboursMarkedClosed.length == 1 ? "is" : "are";
            String a__ = neighboursMarkedClosed.length == 1 ? "a " : "";
            String it_them = neighboursMarkedClosed.length == 1 ? "it" : "them";

            searchHistory..newExplanation(new Explanation.styled("enumeration"))
              ..addES_("${neighboursMarkedClosed.length} neighbour node$__s which $is_are ")
              ..addESM("marked closed", "grey", new CircleHighlight(), neighboursMarkedClosed)
              ..addES_(" $is_are ignored as we have already found $a__")
              ..addEMS("optimal path$__s", "grey", pathsOfClosed, null)
              ..addES_(" from the source node to $it_them. ");
          }
        }

        if (neighboursMarkedOpen.isNotEmpty)
        {
          if (createHistory())
          {
            List<PathHighlight> pathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(getPath(on).toList(), showEnd: true)).toList();
            List<PathHighlight> maybeNewPathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(new List()..addAll(getPath(nStar))..add(on), showEnd: true)).toList();

            String __s = neighboursMarkedOpen.length == 1 ? "" : "s";
            String is_are = neighboursMarkedOpen.length == 1 ? "is" : "are";
            String it_them = neighboursMarkedOpen.length == 1 ? "it" : "them";

            searchHistory..newExplanation(new Explanation.styled("enumeration"))
              ..addES_("${neighboursMarkedOpen.length} neighbour node$__s which $is_are ")
              ..addESM("marked open", "green", new CircleHighlight(), neighboursMarkedOpen)
              ..addES_(" $is_are checked, if we can have an maybe more optimal ")
              ..addEM_("new path", "blue", [new Tuple2(maybeNewPathsOfOpen, [null])]..addAll(neighboursMarkedOpen.map((on) => new Tuple2([new TextHighlight((getDistance(nStar) + new Distance.calc(nStar, on)).length().toStringAsPrecision(3))], [on]))))
              ..addES_(" from our source node to $it_them over the current selected node than the ")
              ..addEM_("current path", "green", [new Tuple2(pathsOfOpen, [null])]..addAll(neighboursMarkedOpen.map((on) => new Tuple2([new TextHighlight(getDistance(on).length().toStringAsPrecision(3))], [on]))))
              ..addES_(" which we have already found for $it_them. ");
          }

          var neighboursMarkedOpenBetterPath = neighboursMarkedOpen.where((n) => getDistance(nStar) + new Distance.calc(nStar, n) < getDistance(n)).toList();

          if (neighboursMarkedOpenBetterPath.isEmpty)
          {
            if (createHistory())
            {
              String __s = neighboursMarkedOpen.length == 1 ? "" : "s";
              String has_have = neighboursMarkedOpen.length == 1 ? "has" : "have";
              String this_these = neighboursMarkedOpen.length == 1 ? "this" : "all ${neighboursMarkedOpen.length}";

              searchHistory
                ..addES_("But $this_these node$__s already $has_have a good path. ");
            }
          }
          else
          {
            neighboursMarkedOpenBetterPath.forEach((n)
            {
              parent[n] = nStar;
              distance[n] = getDistance(nStar) + new Distance.calc(nStar, n);
              updatedNodes.add(n);
            });

            if (createHistory())
            {
              List<PathHighlight> newPathsOfOpen = neighboursMarkedOpenBetterPath.map((on) => new PathHighlight(getPath(on).toList(), showEnd: true)).toList();

              String __s = neighboursMarkedOpenBetterPath.length == 1 ? "" : "s";
              String a__ = neighboursMarkedOpenBetterPath.length == 1 ? "a " : "";

              searchHistory
                ..addES_("And we also found $a__")
                ..addEMS("better path$__s", "blue", newPathsOfOpen, null)
                ..addES_(" for ")
                ..addESM("${neighboursMarkedOpenBetterPath.length} node$__s", "green", new CircleHighlight(), neighboursMarkedOpenBetterPath)
                ..addES_(". ");
            }
          }
        }

        if (neighboursUnmarked.isNotEmpty)
        {
          if (createHistory())
          {
            String __s = neighboursUnmarked.length == 1 ? "" : "s";
            String is_are = neighboursUnmarked.length == 1 ? "is" : "are";

            searchHistory..newExplanation(new Explanation.styled("enumeration"))
              ..addES_("${neighboursUnmarked.length} neighbour node$__s which $is_are ")
              ..addESM("unmarked", "blue", new CircleHighlight(), neighboursUnmarked)
              ..addES_(" $is_are marked as open ");
          }
          neighboursUnmarked.forEach((Position n)
          {
            open.add(n);

            distance[n] = getDistance(nStar) + new Distance.calc(nStar, n);
            parent[n] = nStar;

            updatedNodes.add(n);
          });

          if (createHistory())
          {
            List<PathHighlight> pathsOfUnmarked = neighboursUnmarked.map((on) => new PathHighlight(getPath(on).toList(), showEnd: true)).toList();

            String it_them = neighboursUnmarked.length == 1 ? "it" : "them";

            searchHistory
              ..addES_("and we set the new ")
              ..addEMS("best path", "blue", pathsOfUnmarked, null)
              ..addES_(" from the source node to $it_them over our current selected node. ");
          }
        }
      }

      open.remove(nStar);
      closed.add(nStar);

      if (createHistory())
      {
        searchHistory.addHM("foreground", updatedNodes.map((un) => new Tuple2([new PathHighlight.styled("green", [nStar, un], showEnd: true)], [null])));
        searchHistory.addH_("foreground", [new DotHighlight.styled("yellow")], [nStar]);
        searchHistory.addH_("foreground", [new PathHighlight.styled("yellow", getPath(nStar), showEnd: true)], [null]);
        //searchState.defaultHighlights.add(new CircleHighlight.styled("green", updatedNodes.toSet()));
      }
    }

    searchHistory.stepCount = nextTurn;
    if (searchHistory.foundPath)
    {
      searchHistory.title = "The $name Algorithm took $turn iterations to find a ${getDistance(target).length().toStringAsPrecision(3)} long path";
    }
    else
    {
      searchHistory.title = "The $name Algorithm took $turn iterations to find no path";
    }
  }
}