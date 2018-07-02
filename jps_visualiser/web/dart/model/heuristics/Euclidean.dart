import '../../general/Position.dart';
import 'Heuristic.dart';
import 'dart:math';

class Euclidean implements Heuristic
{
  const Euclidean();

  @override
  double calculateApproximateDistance(Position p1, Position p2)
  {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }
}