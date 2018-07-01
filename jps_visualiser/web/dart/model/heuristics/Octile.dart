import '../../general/Position.dart';
import 'Heuristic.dart';
import 'dart:math';

class Octile implements Heuristic
{
  @override
  double calculateApproximateDistance(Position p1, Position p2)
  {
    int dx = (p1.x - p2.x).abs();
    int dy = (p1.y - p2.y).abs();
    return max(dx, dy) + (sqrt(2) - 1) * min(dx, dy);
  }
}