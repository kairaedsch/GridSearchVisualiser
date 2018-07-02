import '../../general/Position.dart';

abstract class Heuristic
{
  const Heuristic();

  double calculateApproximateDistance(Position p1, Position p2);
}