import '../../general/Position.dart';

abstract class Heuristic
{
  double calculateApproximateDistance(Position p1, Position p2);
}