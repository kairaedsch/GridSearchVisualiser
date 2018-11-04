import 'Direction.dart';
import 'Size.dart';
import 'package:quiver/core.dart';

class Position
{
  final int x;
  final int y;

  const Position(this.x, this.y);

  Position.fromMap(Map map)
      : x = map["x"] as int,
        y = map["y"] as int;

  Position.fromString(String string)
      : x = int.parse(string.substring(string.indexOf("(") + 1, string.indexOf(","))),
        y = int.parse(string.substring(string.indexOf(",") + 1, string.indexOf(")")));

  Map toMap() => new Map<dynamic, dynamic>()
      ..["x"] = x
      ..["y"] = y;

  Position go(Direction direction) => goMulti(direction, 1);

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

  Position goMulti(Direction direction, int length)
  {
    return new Position(x + Directions.getDx(direction) * length, y + Directions.getDy(direction) * length);
  }

  Direction lastDirectionTo(Position targetPosition)
  {
    return _directionTo(targetPosition, true);
  }

  Direction firstDirectionTo(Position targetPosition)
  {
    return _directionTo(targetPosition, false);
  }

  Direction _directionTo(Position targetPosition, bool last)
  {
    int dx = (targetPosition.x - x);
    int dy = (targetPosition.y - y);
    int tdx, tdy;
    if (last && dx.abs() != dy.abs())
    {
      tdx = dx.abs() > dy.abs() ? dx.sign : 0;
      tdy = dx.abs() < dy.abs() ? dy.sign : 0;
    }
    else
    {
      tdx = dx.sign;
      tdy = dy.sign;
    }
    return Direction.values.where((d) => Directions.getDx(d) == tdx && Directions.getDy(d) == tdy).first;
  }

  Iterable<Position> neighbours(Size size)
  {
    return Direction.values
        .map((Direction direction) => go(direction))
        .where((Position position) => position.legal(size));
  }
}