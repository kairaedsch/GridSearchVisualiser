import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../history/SearchHistory.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';
import 'BasicSearchAlgorithm.dart';

class AStar extends BasicSearchAlgorithm
{
   static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new AStar(grid, startPosition, targetPosition, heuristic);

   AStar(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) : super("AStar", grid, startPosition, targetPosition, heuristic);

   @override
   Node findNextActiveNode()
   {
      Node nStar = open.reduce((n1, n2) => (getDistance(n1) + heuristic.calc(n1, target)) <= (getDistance(n2) + heuristic.calc(n2, target)) ? n1 : n2);

      List<PathHighlight> pathsOfOpen = open.map((on) => new PathHighlight.styled("green", getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();
      List<PathHighlight> pathsOfOpenHeuristic = open.map((on) => new PathHighlight.styled("yellow dotted", heuristic.getPath(on, target), showEnd: true)).toList();
      currentSearchState.description.add(new Explanation()
         ..addT("First we look at all nodes which are ")
         ..addH("marked open", "green", [new CircleHighlight(open.map((n) => n.position).toSet())])
         ..addT(". From all these nodes we know a ")
         ..addH("path", "green", pathsOfOpen)
         ..addT(" from the source node to them. ")
         ..addT("Therefore we also know the ")
         ..addH("distance", "green", new List.from(pathsOfOpen)..addAll(open.map((on) => new TextHighlight(getDistance(on).toStringAsPrecision(2), on.position)).toList()))
         ..addT(" between them. ")
         ..addT("And when we also use the ")
         ..addH("$heuristic", "yellow", new List.from(pathsOfOpenHeuristic)..addAll(open.map((on) => new TextHighlight(heuristic.calc(on, target).toStringAsPrecision(2), on.position)).toList()))
         ..addT(" as our heuristic, we can approximate the distance of the nodes to the target node. ")
         ..addT("When we now add both distances, we can ")
         ..addH("approximate the total distance", "yellow", new List.from(pathsOfOpen)..addAll(pathsOfOpenHeuristic)..addAll(open.map((on) => new TextHighlight((heuristic.calc(on, target) + getDistance(on)).toStringAsPrecision(2), on.position)).toList()))
         ..addT(" from the source node to our target node over the open marked nodes. ")
         ..addT("We will now take the node of them, which has the ")
         ..addH("shortest approximated total distance", "green", [new PathHighlight(getPath(nStar).map((n) => n.position).toList(), showEnd: true), new PathHighlight.styled("yellow dotted", heuristic.getPath(nStar, target), showEnd: true), new TextHighlight((heuristic.calc(nStar, target) + getDistance(nStar)).toStringAsPrecision(2), nStar.position)])
         ..addT(" to the target node and make him to the ")
         ..addH("active node", "yellow", [new CircleHighlight(new Set()..add(nStar.position))])
         ..addT(" of this turn. We will also mark him closed, so we can say for sure, that we have found the shortest way from the source node to him. ")
      );

      return nStar;
   }
}
