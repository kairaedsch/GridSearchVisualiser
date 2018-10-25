class DirectionOLD
{
  static const DirectionOLD NORTH      = const DirectionOLD("NORTH",       0, -1, 0);
  static const DirectionOLD NORTH_EAST = const DirectionOLD("NORTH_EAST",  1, -1, 1);
  static const DirectionOLD EAST       = const DirectionOLD("EAST",        1,  0, 2);
  static const DirectionOLD SOUTH_EAST = const DirectionOLD("SOUTH_EAST",  1,  1, 3);
  static const DirectionOLD SOUTH     = const DirectionOLD("SOUTH",        0,  1, 4);
  static const DirectionOLD SOUTH_WEST = const DirectionOLD("SOUTH_WEST", -1,  1, 5);
  static const DirectionOLD WEST       = const DirectionOLD("WEST",       -1,  0, 6);
  static const DirectionOLD NORTH_WEST = const DirectionOLD("NORTH_WEST", -1, -1, 7);

  final String name;

  bool get isDiagonal => dx != 0 && dy != 0;
  bool get isCardinal => !isDiagonal;
  final int dx, dy;
  final int id;

  const DirectionOLD(this.name, this.dx, this.dy, this.id);

  DirectionOLD turn(int plusDeg)
  {
    int deg = values.indexOf(this) * 45 + plusDeg;
    return values[((deg + 360) % 360) ~/ 45];
  }

  String toString() => name;

  Iterable<DirectionOLD> expand(int amount)
  {
    return values.where((d) => (id - d.id).abs() <= amount || (id + 8 - d.id).abs() <= amount || (id - d.id - 8).abs() <= amount);
  }

  static const List<DirectionOLD> values = const <DirectionOLD>[
    NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST];

  static const List<DirectionOLD> cardinals = const <DirectionOLD>[
    NORTH, EAST, SOUTH, WEST];

  static const List<DirectionOLD> diagonals = const <DirectionOLD>[
    NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST];
}