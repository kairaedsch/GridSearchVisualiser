import '../../general/Position.dart';
import 'Heuristic.dart';
import 'dart:math';

class Chebyshev extends Heuristic
{
  const Chebyshev();

  @override
  double calculateApproximateDistanceP(Position p1, Position p2)
  {
    int dx = (p1.x - p2.x).abs();
    int dy = (p1.y - p2.y).abs();
    return max(dx, dy).toDouble();
  }
}