import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'Algorithm.dart';
import 'Dijkstra.dart';
import 'package:tuple/tuple.dart';

class AStar extends Dijkstra
{
   static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new AStar("A*", grid, startPosition, targetPosition, heuristic, turnOfHistory);

   AStar(String name, Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) : super(name, grid, startPosition, targetPosition, heuristic, turnOfHistory);

   @override
   Node findNextActiveNode()
   {
      Node nStar = open.reduce((n1, n2) => (getDistance(n1).length() + heuristic.calc(n1, target)) <= (getDistance(n2).length() + heuristic.calc(n2, target)) ? n1 : n2);

      if (createHistory())
      {
         List<Highlight> pathsOfOpen = open.map((on) => new PathHighlight.styled("green", getPath(on).map((n) => n.position).toList(), showEnd: true)).toList();
         List<Highlight> pathsOfOpenHeuristic = open.map((on) => new PathHighlight.styled("yellow dotted", heuristic.getPath(on, target), showEnd: true)).toList();
         searchHistory..newExplanation(new Explanation())
            ..addES_("First we look at all nodes which are ")
            ..addESM("marked open", "green", new CircleHighlight(), open.map((n) => n.position))
            ..addES_(". From all these nodes we know a ")
            ..addEMS("path", "green", pathsOfOpen, null)
            ..addES_(" from the source node to them. ")
            ..addES_("Therefore we also know the ")
            ..addEM_("distance", "green", [new Tuple2(pathsOfOpen, [null])]..addAll(open.map((on) => new Tuple2([new TextHighlight(getDistance(on).length().toStringAsPrecision(3))], [on.position]))))
            ..addES_(" between them. ")
            ..addES_("And when we also use the ")
            //..addEM_("$heuristic", "yellow", new List.from(pathsOfOpenHeuristic)..addAll(open.map((on) => new TextHighlight(heuristic.calc(on, target).toStringAsPrecision(3), on.position)).toList()))
            ..addES_(" as our heuristic, we can approximate the distance of the nodes to the target node. ")
            ..addES_("When we now add both distances, we can ")
            //..addEM_("approximate the total distance", "yellow", new List.from(pathsOfOpen)..addAll(pathsOfOpenHeuristic)..addAll(open.map((on) => new TextHighlight((heuristic.calc(on, target) + getDistance(on).length()).toStringAsPrecision(3), on.position)).toList()))
            ..addES_(" from the source node to our target node over the open marked nodes. ")
            ..addES_("We will now take the node of them, which has the ")
            //..addEM_("shortest approximated total distance", "green", [new PathHighlight(getPath(nStar).map((n) => n.position).toList(), showEnd: true), new PathHighlight.styled("yellow dotted", heuristic.getPath(nStar, target), showEnd: true), new TextHighlight((heuristic.calc(nStar, target) + getDistance(nStar).length()).toStringAsPrecision(3), nStar.position)])
            ..addES_(" to the target node and make him to the ")
            ..addESS("active node", "yellow", new CircleHighlight(), nStar.position)
            ..addES_(" of this turn. We will also mark him closed, so we can say for sure, that we have found the shortest way from the source node to him. ");
      }

      return nStar;
   }
}
