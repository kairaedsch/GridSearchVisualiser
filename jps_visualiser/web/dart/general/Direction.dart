import 'Position.dart';

class Direction
{
  static const Direction NORTH      = const Direction("NORTH",       0, -1);
  static const Direction NORTH_EAST = const Direction("NORTH_EAST",  1, -1);
  static const Direction EAST       = const Direction("EAST",        1,  0);
  static const Direction SOUTH_EAST = const Direction("SOUTH_EAST",  1,  1);
  static const Direction SOUTH     = const Direction("SOUTH",        0,  1);
  static const Direction SOUTH_WEST = const Direction("SOUTH_WEST", -1,  1);
  static const Direction WEST       = const Direction("WEST",       -1,  0);
  static const Direction NORTH_WEST = const Direction("NORTH_WEST", -1, -1);

  final String name;
  bool get isDiagonal => dx != 0 && dy != 0;
  bool get isCardinal => !isDiagonal;
  final int dx, dy;

  const Direction(this.name, this.dx, this.dy);

  Direction turn(int plusDeg)
  {
    int deg = values.indexOf(this) * 45 + plusDeg;
    return values[((deg + 360) % 360) ~/ 45];
  }

  String toString() => name;

  static const List<Direction> values = const <Direction>[
    NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST];

  static const List<Direction> cardinals = const <Direction>[
    NORTH, EAST, SOUTH, WEST];

  static const List<Direction> diagonals = const <Direction>[
    NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST];
}