import '../../general/geo/Position.dart';
import 'Heuristic.dart';
import 'dart:math';

class Euclidean extends Heuristic
{
  const Euclidean() : super("Euclidean distance");

  @override
  double calc(Position p1, Position p2)
  {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }
  @override
  List<Position> getPath(Position source, Position target)
  {
    return [source, target];
  }
}