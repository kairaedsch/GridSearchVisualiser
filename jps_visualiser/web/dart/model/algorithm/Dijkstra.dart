import '../Grid.dart';
import '../NodeSearchState.dart';
import '../SearchHistory.dart';
import '../SearchState.dart';
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
    List<Node> open = [start];
    List<Node> closed = [];

    while (open.isNotEmpty)
    {
      SearchState searchState = new SearchState(grid);

      Node nStar = open.reduce((n1, n2) => getDistance(n1) <= getDistance(n1) ? n1 : n2);
      searchState[nStar.position].selectedNodeInTurn = true;

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
        searchHistory.path = path;
        break;
      }
      else
      {
        open.remove(nStar);
        closed.add(nStar);

        for (Node n in grid.neighbours(nStar).where((n) => !closed.contains(n)))
        {
          open.add(n);
          if (!distance.containsKey(n) || getDistance(nStar) + nStar.distanceTo(n) <  getDistance(n))
          {
              parent[n] = nStar;
              distance[n] =  getDistance(nStar) + nStar.distanceTo(n);
          }
        }
      }

      open.forEach((n) => searchState[n.position].nodeMarking = NodeMarking.MARKED_OPEN_NODE);
      closed.forEach((n) => searchState[n.position].nodeMarking = NodeMarking.MARKED_CLOSED_NODE);
      searchState.iterable.forEach((n) => n.parent = new Optional.fromNullable(parent[n]));

      searchHistory.add(searchState);
    }
    return searchHistory;
  }
}