import '../../general/Position.dart';
import '../Grid.dart';

abstract class Heuristic
{
  const Heuristic();

  double calculateApproximateDistance(Node n1, Node n2)
  {
    return calculateApproximateDistanceP(n1.position, n2.position);
  }

  double calculateApproximateDistanceP(Position p1, Position p2);
}