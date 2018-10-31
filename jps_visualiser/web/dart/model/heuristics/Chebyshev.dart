import '../../general/geo/Position.dart';
import 'Heuristic.dart';
import 'dart:math';

class Chebyshev extends Heuristic
{
  const Chebyshev() : super("Chebyshev distance");

  @override
  double calc(Position p1, Position p2)
  {
    int dx = (p1.x - p2.x).abs();
    int dy = (p1.y - p2.y).abs();
    return max(dx, dy).toDouble();
  }

  @override
  List<Position> getPath(Position source, Position target)
  {
    int dx = (source.x - target.x).abs();
    int dy = (source.y - target.y).abs();
    if (dx >= dy)
    {
      return [source, new Position(target.x, source.y)];
    }
    else
    {
      return [source, new Position(source.x, target.y)];
    }
  }
}