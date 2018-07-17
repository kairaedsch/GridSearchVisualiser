import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../history/NodeSearchState.dart';
import '../history/SearchHistory.dart';
import '../history/SearchState.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';

typedef Funk<T, R> = R Function(T);

class Dijkstra extends Algorithm
{
  const Dijkstra();

  @override
  SearchHistory search(Grid grid, Node start, Node target, Heuristic heuristic)
  {
    SearchHistory searchHistory = new SearchHistory();

    Map<Node, double> distance = new Map<Node, double>();
    distance[start] = 0.0;
    Funk<Node, double> getDistance = (Node n) => distance.containsKey(n) ? distance[n] : double.INFINITY;

    Map<Node, Node> parent = new Map<Node, Node>();
    Funk<Node, List<Node>> getPath = (Node n)
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
    };

    Set<Node> open = new Set()
      ..add(start);
    Set<Node> closed = new Set();

    int turn;
    for (turn = 1; open.isNotEmpty; turn++)
    {
      SearchState searchState = new SearchState(turn, grid);
      open.forEach((n) => searchState[n.position].nodeMarking = NodeMarking.MARKED_OPEN_NODE);
      closed.forEach((n) => searchState[n.position].nodeMarking = NodeMarking.MARKED_CLOSED_NODE);
      //grid.iterable.forEach((n) => searchState[n.position].addInfo("Current best path is ${getDistance(n)}"));
      searchState.title
        ..addT("Turn $turn")
      ;

      Node nStar = open.reduce((n1, n2) => getDistance(n1) <= getDistance(n2) ? n1 : n2);
      searchState.activeNodeInTurn = nStar.position;

      List<PathHighlight> pathsOfOpen = open.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();
      searchState.description.add(new Explanation()
        ..addT("First we look at all nodes which are ")
        ..addH("marked open", "green", [new PositionHighlight(open.map((n) => n.position).toSet())])
        ..addT(". From all these nodes we know a ")
        ..addH("path", "green", pathsOfOpen)
        ..addT(" from the source node to them. ")
        ..addT("Therefore we also know the ")
        ..addH("distance", "green", new List.from(pathsOfOpen)..addAll(open.map((on) => new TextHighlight(getDistance(on).toStringAsPrecision(2), on.position)).toList()))
        ..addT(" between them. ")
        ..addT("We will now take the node of them, which has the ")
        ..addH("shortest path", "green", [new PathHighlight(getPath(nStar).map((n) => n.position).toList(), showEnd: true), new TextHighlight(getDistance(nStar).toStringAsPrecision(2), nStar.position)])
        ..addT(" to the source node and make him to the ")
        ..addH("active node", "yellow", [new PositionHighlight(new Set()..add(nStar.position))])
        ..addT(" of this turn. We will also mark him closed, so we can say for sure, that we have found the shortest way from the source node to him. ")
      );

      Set<Node> updatedNodes = new Set();

      if (nStar == target)
      {
        searchHistory.setPath(getPath(target));
        break;
      }
      else
      {
        var neighbours = grid.neighbours(nStar);
        var neighboursMarkedClosed = neighbours.where((n) => closed.contains(n)).toList();
        var neighboursMarkedOpen = neighbours.where((n) => open.contains(n)).toList();
        var neighboursUnmarked = neighbours.where((n) => !closed.contains(n) && !open.contains(n)).toList();

        searchState.description.add(new Explanation()
          ..addT("After we have choosen our active node, we will take a look at all of his ")
          ..addH("neighbour nodes", "blue", [new PositionHighlight(neighbours.map((n) => n.position).toSet())])
          ..addT(": ")
        );

        if (neighboursMarkedClosed.isNotEmpty)
        {
          List<PathHighlight> pathsOfClosed = neighboursMarkedClosed.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

          searchState.description.add(new Explanation()
            ..addT("- All neighbour nodes which are ")
            ..addH("marked closed", "grey", [new PositionHighlight(neighboursMarkedClosed.map((n) => n.position).toSet())])
            ..addT(" are ignored as we have already found ")
            ..addH("optimal paths", "grey", pathsOfClosed)
            ..addT(" from the source node to them. ")
          );
        }

        if (neighboursMarkedOpen.isNotEmpty)
        {
          List<PathHighlight> pathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();

          List<PathHighlight> maybeNewPathsOfOpen = neighboursMarkedOpen.map((on) => new PathHighlight(new List()..addAll(getPath(nStar).map((n) => n.position))..add(on.position), showEnd: true)).toList();

          searchState.description.add(new Explanation()
            ..addT("- All neighbour nodes which are ")
            ..addH("marked open", "green", [new PositionHighlight(neighboursMarkedOpen.map((n) => n.position).toSet())])
            ..addT(" are checked, if we can have an maybe more optimal ")
            ..addH("new path", "green", maybeNewPathsOfOpen)
            ..addT(" from our source node to them over the active node than the ")
            ..addH("current path", "green", pathsOfOpen)
            ..addT(" which we have already found for them. ")
          );

          var neighboursMarkedOpenBetterPath = neighboursMarkedOpen.where((n) => getDistance(nStar) + nStar.distanceTo(n) < getDistance(n)).toList();

          if (neighboursMarkedOpenBetterPath.isEmpty)
          {
            searchState.description.last
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

            searchState.description.last
              ..addT("And we also found some ")
              ..addH("better paths", "green", newPathsOfOpen)
              ..addT(" for these ")
              ..addH("nodes", "blue", [new PositionHighlight(neighboursMarkedOpenBetterPath.map((n) => n.position).toSet())])
              ..addT(". ")
            ;
          }
        }

        if (neighboursUnmarked.isNotEmpty)
        {
          searchState.description.add(new Explanation()
            ..addT("- All neighbour nodes which are ")
            ..addH("unmarked", "blue", [new PositionHighlight(neighboursUnmarked.map((n) => n.position).toSet())])
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

          searchState.description.last
            ..addT("and we set the new ")
            ..addH("best path", "blue", pathsOfUnmarked)
            ..addT(" from the source node to them over our active node. ")
          ;
        }
      }

      open.remove(nStar);
      closed.add(nStar);

      updatedNodes.forEach((un) => searchState.defaultHighlights.add(new PathHighlight.styled("black", [nStar.position, un.position], showEnd: true)));
      //searchState.defaultHighlights.add(new PositionHighlight.styled("green", updatedNodes.map((n) => n.position).toSet()));

      searchHistory.add(searchState);
    }

    searchHistory.title = "Searched with dijkstra in $turn turns";

    return searchHistory;
  }
}