import 'Direction.dart';
import 'dart:math';

class Position
{
  final int x;
  final int y;

  const Position(this.x, this.y);

  String toString() => "($x, $y)";

  double length() => sqrt(x * x + y * y);

  Position operator -(Position pos) => new Position(x - pos.x, y - pos.y);

  Position go(Direction direction) => new Position(x + direction.dx, y + direction.dy);

  legal(int width, int height)
  {
    return x >= 0 && x < width && y >= 0 && y < height;
  }
}