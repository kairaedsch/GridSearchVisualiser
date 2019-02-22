import '../../general/geo/Position.dart';
import 'Heuristic.dart';
import 'dart:math';

class Octile extends Heuristic
{
  const Octile() : super("Octile distance");

  @override
  double calc(Position p1, Position p2)
  {
    int dx = (p1.x - p2.x).abs();
    int dy = (p1.y - p2.y).abs();
    return ((max(dx, dy) - min(dx, dy)) + sqrt(2) * min(dx, dy)).toDouble();
  }

  @override
  List<Position> getPath(Position source, Position target)
  {
    List<Position> path = [source];
    while (path.last.x != target.x || path.last.y != target.y)
    {
      int newX = path.last.x + (path.last.x != target.x ? (path.last.x > target.x ? -1 : 1) : 0);
      int newY = path.last.y + (path.last.y != target.y ? (path.last.y > target.y ? -1 : 1) : 0);
      path.add(new Position(newX, newY));
    }
    return path;
  }
}