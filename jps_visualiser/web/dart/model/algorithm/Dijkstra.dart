import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../history/SearchHistory.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';
import 'BasicSearchAlgorithm.dart';

class Dijkstra extends BasicSearchAlgorithm
{
   static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new Dijkstra(grid, startPosition, targetPosition, heuristic);

   Dijkstra(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
       : super("Dijkstra", grid, startPosition, targetPosition, heuristic);

   @override
   Node findNextActiveNode()
   {
      Node nStar = open.reduce((n1, n2) => getDistance(n1).length() <= getDistance(n2).length() ? n1 : n2);

      List<PathHighlight> pathsOfOpen = open.map((on) => new PathHighlight(getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();
      currentSearchState.description.add(new Explanation()
         ..addT("First we look at all nodes which are ")
         ..addH("marked open", "green", [new CircleHighlight(open.map((n) => n.position).toSet())])
         ..addT(". From all these nodes we know a ")
         ..addH("path", "green", pathsOfOpen)
         ..addT(" from the source node to them. ")
         ..addT("Therefore we also know the ")
         ..addH("distance", "green", new List.from(pathsOfOpen)..addAll(open.map((on) => new TextHighlight(getDistance(on).length().toStringAsPrecision(2), on.position)).toList()))
         ..addT(" between them. ")
         ..addT("We will now take the node of them, which has the ")
         ..addH("shortest path", "green", [new PathHighlight(getPath(nStar).map((n) => n.position).toList(), showEnd: true), new TextHighlight(getDistance(nStar).length().toStringAsPrecision(2), nStar.position)])
         ..addT(" to the source node and make him to the ")
         ..addH("active node", "yellow", [new CircleHighlight(new Set()..add(nStar.position))])
         ..addT(" of this turn. We will also mark him closed, so we can say for sure, that we have found the shortest way from the source node to him. ")
      );

      return nStar;
   }
}
