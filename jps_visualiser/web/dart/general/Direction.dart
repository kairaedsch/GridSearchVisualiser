class Direction
{
  static const Direction NORTH = const Direction("NORTH");
  static const Direction NORTH_EAST = const Direction("NORTH_EAST");
  static const Direction EAST = const Direction("EAST");
  static const Direction SOUTH_EAST = const Direction("SOUTH_EAST");
  static const Direction SOUTH = const Direction("SOUTH");
  static const Direction SOUTH_WEST = const Direction("SOUTH_WEST");
  static const Direction WEST = const Direction("WEST");
  static const Direction NORTH_WEST = const Direction("NORTH_WEST");

  final String name;
  String toString() => name;

  const Direction(this.name);

  static const List<Direction> values = const <Direction>[
    NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST];
}