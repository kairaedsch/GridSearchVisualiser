enum Direction
{
  NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST
}

class Directions
{
  static const List<Direction> cardinals = const <Direction>[
    Direction.NORTH, Direction.EAST, Direction.SOUTH, Direction.WEST];

  static const List<Direction> diagonals = const <Direction>[
    Direction.NORTH_EAST, Direction.SOUTH_EAST, Direction.SOUTH_WEST, Direction.NORTH_WEST];

  static bool isCardinal(Direction direction) => cardinals.contains(direction);

  static bool isDiagonal(Direction direction) => diagonals.contains(direction);

  static Direction turn(Direction direction, int plusDeg)
  {
    int deg = direction.index * 45 + plusDeg;
    return Direction.values[((deg + 360) % 360) ~/ 45];
  }

  static int getDx(Direction direction)
  {
    switch (direction)
    {
      case Direction.NORTH      : return  0; break;
      case Direction.NORTH_EAST : return  1; break;
      case Direction.EAST       : return  1; break;
      case Direction.SOUTH_EAST : return  1; break;
      case Direction.SOUTH      : return  0; break;
      case Direction.SOUTH_WEST : return -1; break;
      case Direction.WEST       : return -1; break;
      case Direction.NORTH_WEST : return -1; break;
    }

  }

  static int getDy(Direction direction)
  {
    switch (direction)
    {
      case Direction.NORTH      : return -1; break;
      case Direction.NORTH_EAST : return -1; break;
      case Direction.EAST       : return  0; break;
      case Direction.SOUTH_EAST : return  1; break;
      case Direction.SOUTH      : return  1; break;
      case Direction.SOUTH_WEST : return  1; break;
      case Direction.WEST       : return  0; break;
      case Direction.NORTH_WEST : return -1; break;
  }
  }
}
