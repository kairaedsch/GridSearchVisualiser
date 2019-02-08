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
      case Direction.NORTH     : return  0;
      case Direction.NORTH_EAST: return  1;
      case Direction.EAST      : return  1;
      case Direction.SOUTH_EAST: return  1;
      case Direction.SOUTH     : return  0;
      case Direction.SOUTH_WEST: return -1;
      case Direction.WEST      : return -1;
      case Direction.NORTH_WEST: return -1;
    }
    throw new Exception("Invalid");
  }

  static int getDy(Direction direction)
  {
    switch (direction)
    {
      case Direction.NORTH     : return -1;
      case Direction.NORTH_EAST: return -1;
      case Direction.EAST      : return  0;
      case Direction.SOUTH_EAST: return  1;
      case Direction.SOUTH     : return  1;
      case Direction.SOUTH_WEST: return  1;
      case Direction.WEST      : return  0;
      case Direction.NORTH_WEST: return -1;
    }
    throw new Exception("Invalid");
  }

  static String getName(Direction direction)
  {
    switch (direction)
    {
      case Direction.NORTH     : return "north";
      case Direction.NORTH_EAST: return "northeast";
      case Direction.EAST      : return "east";
      case Direction.SOUTH_EAST: return "southeast";
      case Direction.SOUTH     : return "south";
      case Direction.SOUTH_WEST: return "southwest";
      case Direction.WEST      : return "west";
      case Direction.NORTH_WEST: return "northwest";
    }
    return "Not Found";
  }
}
