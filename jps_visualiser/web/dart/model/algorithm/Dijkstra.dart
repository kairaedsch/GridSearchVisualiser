import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/NodeSearchState.dart';
import '../history/SearchHistory.dart';
import '../history/SearchState.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';
import 'package:quiver/core.dart';

class Dijkstra extends Algorithm
{
  const Dijkstra();

  @override
  SearchHistory search(Grid grid, Node start, Node target, Heuristic heuristic)
  {
    SearchHistory searchHistory = new SearchHistory();

    Map<Node, double> distance = new Map<Node, double>();
    distance[start] = 0.0;
    Function getDistance = (n) => distance.containsKey(n) ? distance[n] : double.INFINITY;

    Map<Node, Node> parent = new Map<Node, Node>();
    Set<Node> open = new Set()
      ..add(start);
    Set<Node> closed = new Set();

    int turn;
    for (turn = 1; open.isNotEmpty; turn++)
    {
      SearchState searchState = new SearchState(turn, grid);

      searchState.title = new Explanation()
        ..addT("Turn $turn")
      ;

      Node nStar = open.reduce((n1, n2) => getDistance(n1) <= getDistance(n2) ? n1 : n2);
      searchState.activeNodeInTurn = nStar.position;
      searchState[nStar.position].addInfo("I am the active node in this turn. ");

      searchState.description.add(new Explanation()
        ..addT("First we look at all nodes which are ")
        ..addN("marked open", open.map((n) => n.position).toList(), "green")
        ..addT(". From all these nodes we know a path from the source node to them. ")
        ..addT("Therefore we also know the distance between them. ")
        ..addT("We will now take the node of them, which has the shortest path to the source node and make him to the ")
        ..addN("active node", [nStar.position], "yellow")
        ..addT(" of this turn. We will also mark him closed, so we can say for sure, that we have found the shortest way from the source node to him. ")
      );

      if (nStar == target)
      {
        List<Node> path = [];
        {
          Node n = target;
          while (n != start)
          {
            path.add(n);
            n = parent[n];
          }
          path = path.reversed.toList();
        }
        searchHistory.setPath(path);
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
          ..addN("neighbour nodes", neighbours.map((n) => n.position).toList(), "blue")
          ..addT(": ")
        );

        if (neighboursMarkedClosed.isNotEmpty)
        {
          searchState.description.add(new Explanation()
            ..addT("- All neighbour nodes which are ")
            ..addN("marked closed", neighboursMarkedClosed.map((n) => n.position).toList(), "grey")
            ..addT(" are ignored as we have already found an optimal path from the source node to them. ")
          );

          neighboursMarkedClosed.forEach((n)
          {
            searchState[n.position].addInfo("Although I am a neighbour of the active node, I am ignored as I am marked as closed. Therefore we can asume, that we already found the best path from the source node to me.");
          });
        }

        if (neighboursMarkedOpen.isNotEmpty)
        {
          searchState.description.add(new Explanation()
            ..addT("- All neighbour nodes which are ")
            ..addN("marked open", neighboursMarkedOpen.map((n) => n.position).toList(), "green")
            ..addT(" are checked, if we can have an more optimal path from our source node to them over the active node than the path which we have already found for them. ")
          );

          neighboursMarkedOpen.forEach((n)
          {
            searchState[n.position].addInfo("I am already in the open set.");
          });

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
              searchState.parentUpdated.add(n.position);
            });

            searchState.description.last
              ..addT("And we also found some better paths for these ")
              ..addN("nodes", neighboursMarkedOpenBetterPath.map((n) => n.position).toList(), "blue")
              ..addT(". ")
            ;
          }
        }

        if (neighboursUnmarked.isNotEmpty)
        {
          searchState.description.add(new Explanation()
            ..addT("- All neighbour nodes which are ")
            ..addN("unmarked", neighboursUnmarked.map((n) => n.position).toList(), "blue")
            ..addT(" are marked as open and we set the current best path from the source node to them over our active node. ")
          );

          neighboursUnmarked.forEach((n)
          {
            open.add(n);
            searchState.markedOpenInTurn.add(n.position);

            distance[n] = getDistance(nStar) + nStar.distanceTo(n);
            parent[n] = nStar;
            searchState.parentUpdated.add(n.position);

            searchState[n.position].addInfo("I am newly marked as open as I am a neighbour of the active node and have not been marked yet. ");
          });

        }
      }

      open.remove(nStar);
      closed.add(nStar);

      open.forEach((n) => searchState[n.position].nodeMarking = NodeMarking.MARKED_OPEN_NODE);
      closed.forEach((n) => searchState[n.position].nodeMarking = NodeMarking.MARKED_CLOSED_NODE);
      parent.forEach((n, p) => searchState[n.position].parent = new Optional.of(p.position));

      searchHistory.add(searchState);
    }

    searchHistory.title = "Searched with dijkstra in $turn turns";

    return searchHistory;
  }
}