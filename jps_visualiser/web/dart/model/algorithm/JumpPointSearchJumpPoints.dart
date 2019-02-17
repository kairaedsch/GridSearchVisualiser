import '../../general/geo/Position.dart';
import '../store/grid/GridCache.dart';
import '../../general/geo/Direction.dart';

class DirectedJumpPointSearchJumpPoints
{
  static Set<Direction> jumpDirections(GridCache grid, Position position, Direction direction, bool hasNextCardinalPointOfInterest(Position position, Direction direction), bool isForPreCalculation)
  {
    if (Directions.isDiagonal(direction))
    {
      return _diagonalJumpDirections(grid, position, direction, hasNextCardinalPointOfInterest, isForPreCalculation);
    }
    else
    {
      return _cardinalJumpDirections(grid, position, direction);
    }
  }

  static Set<Direction> _cardinalJumpDirections(GridCache grid, Position position, Direction direction)
  {
    Direction direction180 = Directions.turn(direction, 180);
    Position wpBefore = position.go(direction180);

    if (!grid.leaveAble(wpBefore, direction))
    {
      return new Set();
    }

    Set<Direction> jumpDirections = new Set();

    for (int side in [1, -1])
    {
      Direction direction45 = Directions.turn(direction, 45 * side);
      Direction direction90 = Directions.turn(direction, 90 * side);
      Direction direction135 = Directions.turn(direction, 135 * side);

      if (grid.leaveAble(position, direction45))
      {
        bool canNotGoDiagonalBefore = !grid.leaveAble(wpBefore, direction45) || !grid.leaveAble(wpBefore.go(direction45), direction);
        if (canNotGoDiagonalBefore)
        {
          jumpDirections.add(direction45);
        }
      }

      if (grid.leaveAble(position, direction90))
      {
        bool canNotGoShorterDiagonalBefore = !grid.leaveAble(wpBefore, direction45);
        if (canNotGoShorterDiagonalBefore)
        {
          // bool canNotGoCardinalBefore = !grid.leaveAble(wpBefore, direction90) || !grid.leaveAble(wpBefore.go(direction90), direction);
          // if (side == 1 || canNotGoCardinalBefore)
          // {
            jumpDirections.add(direction90);
          // }
        }
      }

      if (grid.leaveAble(position, direction135))
      {
        bool canNotGoShorterCardinalBefore = !grid.leaveAble(wpBefore, direction90);
        if (canNotGoShorterCardinalBefore)
        {
          bool canNotGoDiagonalBefore1 = !grid.leaveAble(wpBefore, direction45) || !grid.leaveAble(wpBefore.go(direction45),  direction180);
          bool canNotGoDiagonalBefore2 = !grid.leaveAble(wpBefore, direction135) || !grid.leaveAble(wpBefore.go(direction135),  direction);
          if (canNotGoDiagonalBefore1 && canNotGoDiagonalBefore2)
          {
            // bool canNotGoCardinalBefore = !grid.leaveAble(wpBefore, direction180) || !grid.leaveAble(wpBefore.go(direction180),  direction45);
            // if (side == 1 || canNotGoCardinalBefore)
            // {
              jumpDirections.add(direction135);
            // }
          }
        }
      }
    }

    return jumpDirections;
  }

  static Set<Direction> _diagonalJumpDirections(GridCache grid, Position position, Direction direction, bool hasNextCardinalPointOfInterest(Position position, Direction direction), bool isForPreCalculation)
  {
    Direction direction180 = Directions.turn(direction,180);
    Position wpBefore = position.go(direction180);

    if (!grid.leaveAble(wpBefore, direction))
    {
      return new Set();
    }

    Set<Direction> jumpDirections = new Set();

    for (int side in [1, -1])
    {
      Direction direction45 = Directions.turn(direction,45 * side);
      Direction direction90 = Directions.turn(direction,90 * side);
      Direction direction135 = Directions.turn(direction,135 * side);

      if (grid.leaveAble(position, direction45))
      {
        bool jumpPointAhead = hasNextCardinalPointOfInterest(position, direction45);
        if (jumpPointAhead)
        {
          jumpDirections.add(direction45);
        }
      }

      if (grid.leaveAble(position, direction90))
      {
        bool canNotGoCardinalBefore = !grid.leaveAble(wpBefore, direction45) || !grid.leaveAble(wpBefore.go(direction45), direction45);
        if (canNotGoCardinalBefore)
        {
          // bool canNotGoDiagonalBefore = !grid.leaveAble(wpBefore, direction90) || !grid.leaveAble(wpBefore.go(direction90), direction);
          // if (side == 1 || canNotGoDiagonalBefore)
          // {
            jumpDirections.add(direction90);
          // }
        }
      }

      if (grid.leaveAble(position, direction135))
      {
        bool canNotGoCardinalBefore = !grid.leaveAble(wpBefore, direction45);
        if (canNotGoCardinalBefore)
        {
          // Direction direction_45 = Directions.turn(direction,45 * side * -1);
          // bool canNotGoDiagonalBefore1 = !grid.leaveAble(wpBefore, direction90) || !grid.leaveAble(wpBefore.go(direction90),  direction_45);
          // //bool canNotGoDiagonalBefore2 = !grid.leaveAble(wpBefore, direction135) || !grid.leaveAble(wpBefore.go(direction135), direction);
          // //bool canNotGoDiagonalBefore3 = !grid.leaveAble(wpBefore, direction_45) || !grid.leaveAble(wpBefore.go(direction_45), direction90);
          // if (side == 1 || canNotGoDiagonalBefore1)
          // {
            if (isForPreCalculation || hasNextCardinalPointOfInterest(position, direction135))
            {
              jumpDirections.add(direction135);
            }
          // }
        }
      }
    }

    return jumpDirections;
  }
}