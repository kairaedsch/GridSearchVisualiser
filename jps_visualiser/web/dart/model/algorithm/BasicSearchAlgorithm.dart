import '../../general/Distance.dart';
import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../history/SearchHistory.dart';
import '../history/SearchState.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';

abstract class BasicSearchAlgorithm extends Algorithm
{
  final String name;

  Map<Node, Distance> distance;
  Map<Node, Node> parent;

  Set<Node> open;
  Set<Node> closed;

  BasicSearchAlgorithm(this.name, Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) : super(grid, startPosition, targetPosition, heuristic)
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
    addSearchState();

    distance[start] = new Distance(0, 0);
    open.add(start);
    currentSearchState.title
      ..addT("Setup")
    ;
    currentSearchState.description.add(new Explanation()
      ..addT("For the setup we: ")
    );
    currentSearchState.description.add(new Explanation.styled("enumeration")
      ..addT("Set all nodes unmarked.")
    );
    currentSearchState.description.add(new Explanation.styled("enumeration")
      ..addT("Set the distance from our ")
      ..addH("start node", "green", [new CircleHighlight(new Set()..add(start.position))])
      ..addT(" to our ")
      ..addH("start node", "green", [new CircleHighlight(new Set()..add(start.position))])
      ..addT(" to 0.0.")
    );
    currentSearchState.description.add(new Explanation.styled("enumeration")
      ..addT("Mark our ")
      ..addH("start node open", "green", [new BoxHighlight.styled("green", new Set()..add(start.position))])
      ..addT(".")
    );
    searchHistory.add(currentSearchState);

    int turn;
    for (turn = 1; open.isNotEmpty; turn++)
    {
      addSearchState();
      currentSearchState.title
        ..addT("Turn $turn")
      ;

      Node nStar = findNextActiveNode();

      currentSearchState.backgroundHighlights.add(new BoxHighlight.styled("green", open.map((n) => n.position).toSet()));
      currentSearchState.backgroundHighlights.add(new BoxHighlight.styled("grey", closed.map((n) => n.position).toSet()));

      Set<Node> updatedNodes = new Set();

      if (nStar == target)
      {
        searchHistory.setPath(getPath(target));

        currentSearchState.description.add(new Explanation()
          ..addT("As our active node is our ")
          ..addH("target node", "red", [new CircleHighlight(new Set()..add(target.position))])
          ..addT(", the algorithm can finish and we have found an ")
          ..addH("optimal path", "blue", [new PathHighlight.styled("blue blinking", getPath(target).map((n) => n.position).toList(), showEnd: true)])
          ..addT(" from the ")
          ..addH("source node", "green", [new CircleHighlight(new Set()..add(start.position))])
          ..addT(" to the ")
          ..addH("target node", "red", [new CircleHighlight(new Set()..add(target.position))])
          ..addT(".")
        );

        currentSearchState.defaultHighlights.add(new DotHighlight.styled("yellow", new Set()..add(nStar.position)));
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
          List<PathHighlight> pathsOfClosed = neighboursMarkedClosed.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

          currentSearchState.description.add(new Explanation.styled("enumeration")
            ..addT("All neighbour nodes which are ")
            ..addH("marked closed", "grey", [new CircleHighlight(neighboursMarkedClosed.map((n) => n.position).toSet())])
            ..addT(" are ignored as we have already found ")
            ..addH("optimal paths", "grey", pathsOfClosed)
            ..addT(" from the source node to them. ")
          );
        }

        if (neighboursMarkedOpen.isNotEmpty)
        {
          List<PathHighlight> pathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

          List<PathHighlight> maybeNewPathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(new List()..addAll(getPath(nStar).map((n) => n.position))..add(on.position), showEnd: true)).toList();

          currentSearchState.description.add(new Explanation.styled("enumeration")
            ..addT("All neighbour nodes which are ")
            ..addH("marked open", "green", [new CircleHighlight(neighboursMarkedOpen.map((n) => n.position).toSet())])
            ..addT(" are checked, if we can have an maybe more optimal ")
            ..addH("new path", "blue", new List.from(maybeNewPathsOfOpen)..addAll(neighboursMarkedOpen.map((on) => new TextHighlight((getDistance(nStar) + nStar.distanceTo(on)).length().toStringAsPrecision(2), on.position)).toList()))
            ..addT(" from our source node to them over the active node than the ")
            ..addH("current path", "green", new List.from(pathsOfOpen)..addAll(neighboursMarkedOpen.map((on) => new TextHighlight(getDistance(on).length().toStringAsPrecision(2), on.position)).toList()))
            ..addT(" which we have already found for them. ")
          );

          var neighboursMarkedOpenBetterPath = neighboursMarkedOpen.where((n) => getDistance(nStar) + nStar.distanceTo(n) < getDistance(n)).toList();

          if (neighboursMarkedOpenBetterPath.isEmpty)
          {
            currentSearchState.description.last
              ..addT("But all these nodes already have an good path. ")
            ;
          }
          else
          {
            neighboursMarkedOpenBetterPath.forEach((n)
            {
              parent[n] = nStar;
              distance[n] = getDistance(nStar) + nStar.distanceTo(n);
              updatedNodes.add(n);
            });

            List<PathHighlight> newPathsOfOpen = neighboursMarkedOpenBetterPath.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

            currentSearchState.description.last
              ..addT("And we also found some ")
              ..addH("better paths", "blue", newPathsOfOpen)
              ..addT(" for these ")
              ..addH("nodes", "green", [new CircleHighlight(neighboursMarkedOpenBetterPath.map((n) => n.position).toSet())])
              ..addT(". ")
            ;
          }
        }

        if (neighboursUnmarked.isNotEmpty)
        {
          currentSearchState.description.add(new Explanation.styled("enumeration")
            ..addT("All neighbour nodes which are ")
            ..addH("unmarked", "blue", [new CircleHighlight(neighboursUnmarked.map((n) => n.position).toSet())])
            ..addT(" are marked as open ")
          );

          neighboursUnmarked.forEach((Node n)
          {
            open.add(n);

            distance[n] = getDistance(nStar) + nStar.distanceTo(n);
            parent[n] = nStar;

            updatedNodes.add(n);
          });

          List<PathHighlight> pathsOfUnmarked = neighboursUnmarked.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

          currentSearchState.description.last
            ..addT("and we set the new ")
            ..addH("best path", "blue", pathsOfUnmarked)
            ..addT(" from the source node to them over our active node. ")
          ;
        }
      }

      open.remove(nStar);
      closed.add(nStar);

      updatedNodes.forEach((un) => currentSearchState.defaultHighlights.add(new PathHighlight.styled("black", [nStar.position, un.position], showEnd: true)));
      currentSearchState.defaultHighlights.add(new DotHighlight.styled("yellow", new Set()..add(nStar.position)));
      //searchState.defaultHighlights.add(new CircleHighlight.styled("green", updatedNodes.map((n) => n.position).toSet()));
    }

    searchHistory.title = "Searched with $name in $turn turns";
  }
}