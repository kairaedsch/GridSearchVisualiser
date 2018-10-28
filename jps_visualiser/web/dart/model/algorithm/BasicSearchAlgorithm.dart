import '../../general/Distance.dart';
import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';
import 'Dijkstra.dart';
import 'package:tuple/tuple.dart';

abstract class BasicSearchAlgorithm extends Algorithm
{
  final String name;

  Map<Node, Distance> distance;
  Map<Node, Node> parent;

  Set<Node> open;
  Set<Node> closed;

  BasicSearchAlgorithm(this.name, Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) : super(grid, startPosition, targetPosition, heuristic, turnOfHistory)
  {
    distance = new Map<Node, Distance>();
    parent = new Map<Node, Node>();
    open = new Set();
    closed = new Set();
  }

  Node findNextActiveNode();

  Iterable<Node> findNeighbourNodes(Node node);

  Distance getDistance(Node n)
  {
    return distance.containsKey(n) ? distance[n] : Distance.INFINITY;
  }

  List<Node> getPath(Node n)
  {
    if (parent[n] == null)
    {
      return [];
    }
    List<Node> path = [];
    {
      path.add(n);
      Node intermediateNode = n;
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
        ..addESS("start node", "green", new CircleHighlight(), start.position)
        ..addES_(" to our ")
        ..addESS("start node", "green", new CircleHighlight(), start.position)
        ..addES_(" to 0.0.");

      searchHistory..newExplanation(new Explanation.styled("enumeration"))
        ..addES_("Mark our ")
        ..addESS("start node open", "green", new BoxHighlight(), start.position)
        ..addES_(".");
    }

    int turn;
    for (turn = 1; open.isNotEmpty; turn++)
    {
      tunIsOver();

      if (createHistory())
      {
        searchHistory.stepTitle = "Turn $turn";
      }
      Node nStar = findNextActiveNode();

      if (createHistory())
      {
        searchHistory.addH_("background", [new BoxHighlight.styled("green")], open.map((n) => n.position));
        searchHistory.addH_("background", [new BoxHighlight.styled("grey")], closed.map((n) => n.position));
      }

      Set<Node> updatedNodes = new Set();

      if (nStar == target)
      {
        if (createHistory())
        {
          var optimalPath = new PathHighlight.styled("blue blinking", getPath(target).map((n) => n.position).toList(), showEnd: true);
          searchHistory..newExplanation(new Explanation())
            ..addES_("As our active node is our ")
            ..addESS("target node", "red", new CircleHighlight(), target.position)
            ..addES_(", the algorithm can finish and we have found an ")
            ..addESS("optimal path", "blue", optimalPath, null)
            ..addES_(" from the ")
            ..addESS("source node", "green", new CircleHighlight(), start.position)
            ..addES_(" to the ")
            ..addESS("target node", "red", new CircleHighlight(), target.position)
            ..addES_(".");

          searchHistory.addH_("foreground", [optimalPath], [null]);
          searchHistory.addH_("foreground", [new DotHighlight.styled("yellow")], [nStar.position]);
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
            List<PathHighlight> pathsOfClosed = neighboursMarkedClosed.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

            searchHistory..newExplanation(new Explanation.styled("enumeration"))
              ..addES_("All neighbour nodes which are ")
              ..addESM("marked closed", "grey", new CircleHighlight(), neighboursMarkedClosed.map((n) => n.position))
              ..addES_(" are ignored as we have already found ")
              ..addEMS("optimal paths", "grey", pathsOfClosed, null)
              ..addES_(" from the source node to them. ");
          }
        }

        if (neighboursMarkedOpen.isNotEmpty)
        {
          if (createHistory())
          {
            List<PathHighlight> pathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();
            List<PathHighlight> maybeNewPathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(new List()..addAll(getPath(nStar).map((n) => n.position))..add(on.position), showEnd: true)).toList();

            searchHistory..newExplanation(new Explanation.styled("enumeration"))
              ..addES_("All neighbour nodes which are ")
              ..addESM("marked open", "green", new CircleHighlight(), neighboursMarkedOpen.map((n) => n.position))
              ..addES_(" are checked, if we can have an maybe more optimal ")
              ..addEM_("new path", "blue", [new Tuple2(maybeNewPathsOfOpen, [null])]..addAll(neighboursMarkedOpen.map((on) => new Tuple2([new TextHighlight((getDistance(nStar) + nStar.distanceTo(on)).length().toStringAsPrecision(3))], [on.position]))))
              ..addES_(" from our source node to them over the active node than the ")
              ..addEM_("current path", "green", [new Tuple2(pathsOfOpen, [null])]..addAll(neighboursMarkedOpen.map((on) => new Tuple2([new TextHighlight(getDistance(on).length().toStringAsPrecision(3))], [on.position]))))
              ..addES_(" which we have already found for them. ");
          }

          var neighboursMarkedOpenBetterPath = neighboursMarkedOpen.where((n) => getDistance(nStar) + nStar.distanceTo(n) < getDistance(n)).toList();

          if (neighboursMarkedOpenBetterPath.isEmpty)
          {
            if (createHistory())
            {
              searchHistory
                ..addES_("But all these nodes already have an good path. ");
            }
          }
          else
          {
            neighboursMarkedOpenBetterPath.forEach((n)
            {
              parent[n] = nStar;
              distance[n] = getDistance(nStar) + nStar.distanceTo(n);
              updatedNodes.add(n);
            });

            if (createHistory())
            {
              List<PathHighlight> newPathsOfOpen = neighboursMarkedOpenBetterPath.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

              searchHistory
                ..addES_("And we also found some ")
                ..addEMS("better paths", "blue", newPathsOfOpen, null)
                ..addES_(" for these ")
                ..addESM("nodes", "green", new CircleHighlight(), neighboursMarkedOpenBetterPath.map((n) => n.position))
                ..addES_(". ");
            }
          }
        }

        if (neighboursUnmarked.isNotEmpty)
        {
          if (createHistory())
          {
            searchHistory..newExplanation(new Explanation.styled("enumeration"))
              ..addES_("All neighbour nodes which are ")
              ..addESM("unmarked", "blue", new CircleHighlight(), neighboursUnmarked.map((n) => n.position))
              ..addES_(" are marked as open ");
          }
          neighboursUnmarked.forEach((Node n)
          {
            open.add(n);

            distance[n] = getDistance(nStar) + nStar.distanceTo(n);
            parent[n] = nStar;

            updatedNodes.add(n);
          });

          if (createHistory())
          {
            List<PathHighlight> pathsOfUnmarked = neighboursUnmarked.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

            searchHistory
              ..addES_("and we set the new ")
              ..addEMS("best path", "blue", pathsOfUnmarked, null)
              ..addES_(" from the source node to them over our active node. ");
          }
        }
      }

      open.remove(nStar);
      closed.add(nStar);

      if (createHistory())
      {
        searchHistory.addHM("forground", updatedNodes.map((un) => new Tuple2([new PathHighlight.styled("black", [nStar.position, un.position], showEnd: true)], [null])));
        searchHistory.addH_("foreground", [new DotHighlight.styled("yellow")], [nStar.position]);
        //searchState.defaultHighlights.add(new CircleHighlight.styled("green", updatedNodes.map((n) => n.position).toSet()));
      }
    }

    searchHistory.stepCount = nextTurn;
    if (name == "norecursion")
    {
      searchHistory.title = "Test run";
    }
    else
    {
      Dijkstra dijkstra = new Dijkstra("norecursion", grid, start.position, target.position, heuristic, -1);
      dijkstra.run();
      if (searchHistory.foundPath)
      {
        bool optimal = dijkstra.getDistance(dijkstra.target) == getDistance(target);
        searchHistory.title = "The $name Algorithm took $turn turns to find a ${getDistance(target).length().toStringAsPrecision(3)} long ${optimal ? "optimal path" : "NON OPTIMAL path => Have you found a bug?"}";
      }
      else
      {
        bool thereExistsNone = !dijkstra.searchHistory.foundPath;
        searchHistory.title = "The $name Algorithm took $turn turns to find no path ${thereExistsNone ? "and there really exists none" : "altough there exists one => Have you found a bug?"}";
      }
    }
  }
}