import '../../general/geo/Position.dart';
import '../store/grid/GridCache.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';
import 'BasicSearchAlgorithm.dart';
import 'package:tuple/tuple.dart';

class Dijkstra extends BasicSearchAlgorithm
{
   static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new Dijkstra("Dijkstra", grid, startPosition, targetPosition, heuristic, turnOfHistory);

   Dijkstra(String name, GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory)
       : super(name, grid, startPosition, targetPosition, heuristic, turnOfHistory);

   @override
   Position findNextActiveNode()
   {
      Position nStar = open.reduce((n1, n2) => getDistance(n1).length() <= getDistance(n2).length() ? n1 : n2);

      if (createHistory())
      {
         List<PathHighlight> pathsOfOpen = open.map((on) => new PathHighlight(getPath(on).toList(), showEnd: true)).toList();
         searchHistory..newExplanation(new Explanation())
            ..addES_("First we look at all nodes which are ")
            ..addESM("marked open", "green", new CircleHighlight(), open)
            ..addES_(". From all these nodes we know a ")
            ..addEMS("path", "green", pathsOfOpen, null)
            ..addES_(" from the source node to them. ")
            ..addES_("Therefore we also know the ")
            ..addEM_("distance", "green", [new Tuple2(pathsOfOpen, [null])]..addAll(open.map((on) => new Tuple2([new TextHighlight(getDistance(on).length().toStringAsPrecision(3))], [on]))))
            ..addES_(" between them. ")
            ..addES_("We will now take the node of them, which has the ")
            ..addEM_("shortest path", "green", [new Tuple2([new PathHighlight(getPath(nStar).toList(), showEnd: true)], [null]), new Tuple2([new TextHighlight(getDistance(nStar).length().toStringAsPrecision(3))], [nStar])])
            ..addES_(" to the source node and make him to the ")
            ..addESS("current selected node", "yellow", new CircleHighlight(), nStar)
            ..addES_(" of this iteration. We will also mark him closed, so we can say for sure, that we have found the shortest way from the source node to him. ");
      }

      return nStar;
   }

   @override
   Iterable<Position> findNeighbourNodes(Position node)
   {
      var neighbours = grid.accessibleNeighbours(node);

      if (createHistory())
      {
         String __s = neighbours.length == 1 ? "" : "s";

         searchHistory..newExplanation(new Explanation())
            ..addES_("After we have choosen our current selected node, we will take a look at his ")
            ..addESM("${neighbours.length} neighbour node$__s", "blue", new CircleHighlight(), neighbours)
            ..addES_(": ");
      }

      return neighbours;
   }
}
