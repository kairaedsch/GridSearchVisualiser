import '../../general/Position.dart';
import '../Grid.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import '../heuristics/Heuristic.dart';
import 'AStar.dart';
import 'Algorithm.dart';

class JumpPointSearch extends AStar
{
   static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new JumpPointSearch("JPS", grid, startPosition, targetPosition, heuristic);

   JumpPointSearch(String name, Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
       : super(name, grid, startPosition, targetPosition, heuristic);

   @override
   Iterable<Node> findNeighbourNodes(Node node)
   {
      var neighbours = grid.neighbours(node);

      currentSearchState.description.add(new Explanation()
         ..addT("This is not JPS. Please implement it. After we have choosen our active node, we will take a look at all of his ")
         ..addH("neighbour nodes", "blue", [new CircleHighlight(neighbours.map((n) => n.position).toSet())])
         ..addT(": ")
      );

      return neighbours;
   }
}
