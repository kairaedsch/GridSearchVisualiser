import 'Direction.dart';
import 'Size.dart';
import 'dart:math';

class Position
{
  final int x;
  final int y;

  const Position(this.x, this.y);

  double length() => sqrt(x * x + y * y);

  Position operator -(Position pos) => new Position(x - pos.x, y - pos.y);

  Position operator +(Position pos) => new Position(x + pos.x, y + pos.y);

  Position operator *(int scale) => new Position(x * scale, y * scale);

  Position go(Direction direction) => new Position(x + direction.dx, y + direction.dy);

  bool legal(Size size)
  {
    return x >= 0 && x < size.width && y >= 0 && y < size.height;
  }

  @override
  String toString() => "($x, $y)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Position &&
              runtimeType == other.runtimeType &&
              x == other.x &&
              y == other.y;

  @override
  int get hashCode =>
      x.hashCode ^
      y.hashCode;
}