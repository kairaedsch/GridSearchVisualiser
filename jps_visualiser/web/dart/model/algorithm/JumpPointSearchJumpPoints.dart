import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../Grid.dart';
import '../heuristics/Heuristic.dart';
import '../history/Highlight.dart';
import 'Algorithm.dart';

class JumpPointSearchJumpPoints
{
  static Set<Direction> cardinalJumpDirections(Grid grid, Position position, Direction direction)
  {
    Direction direction180 = direction.turn(180);
    Position wpBefore = position.go(direction180);

    if (!grid.leaveAble(wpBefore, direction))
    {
      return new Set();
    }

    Set<Direction> jumpDirections = new Set();

    for (int side in [1, -1])
    {
      Direction direction45 = direction.turn(45 * side);
      Direction direction90 = direction.turn(90 * side);
      Direction direction135 = direction.turn(135 * side);

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
        bool canNotGoDiagonalBefore = !grid.leaveAble(wpBefore, direction45);
        if (canNotGoDiagonalBefore)
        {
          bool canNotGoCardinalBefore = !grid.leaveAble(wpBefore, direction90) || !grid.leaveAble(wpBefore.go(direction90), direction);
          if (side == 1 || canNotGoCardinalBefore)
          {
            jumpDirections.add(direction90);
          }
        }
      }

      if (grid.leaveAble(position, direction135))
      {
        bool canNotGoCardinalBefore = !grid.leaveAble(wpBefore, direction90);
        if (canNotGoCardinalBefore)
        {
          bool canNotGoDiagonalBefore1 = !grid.leaveAble(wpBefore, direction180) || !grid.leaveAble(wpBefore.go(direction180),  direction45);
          bool canNotGoDiagonalBefore2 = !grid.leaveAble(wpBefore, direction45) || !grid.leaveAble(wpBefore.go(direction45),  direction180);
          bool canNotGoDiagonalBefore3 = !grid.leaveAble(wpBefore, direction135) || !grid.leaveAble(wpBefore.go(direction135),  direction);
          if (canNotGoDiagonalBefore1 && canNotGoDiagonalBefore2 && canNotGoDiagonalBefore3)
          {
            jumpDirections.add(direction135);
          }
        }
      }
    }

    return jumpDirections;
  }

  static Set<Direction> diagonalJumpDirections(Grid grid, Position position, Direction direction, bool isJumpPoint(Position position, Direction direction))
  {
    Direction direction180 = direction.turn(180);
    Position wpBefore = position.go(direction180);

    if (!grid.leaveAble(wpBefore, direction))
    {
      return new Set();
    }

    Set<Direction> jumpDirections = new Set();

    for (int side in [1, -1])
    {
      Direction direction45 = direction.turn(45 * side);
      Direction direction90 = direction.turn(90 * side);
      Direction direction135 = direction.turn(135 * side);

      if (grid.leaveAble(position, direction45))
      {
        bool jumpPointAhead = isJumpPoint(position, direction45);
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
          bool canNotGoDiagonalBefore = !grid.leaveAble(wpBefore, direction90) || !grid.leaveAble(wpBefore.go(direction90), direction);
          if (side == 1 || canNotGoDiagonalBefore)
          {
            jumpDirections.add(direction90);
          }
        }
      }

      if (grid.leaveAble(position, direction135))
      {
        bool canNotGoCardinalBefore = !grid.leaveAble(wpBefore, direction45);
        if (canNotGoCardinalBefore)
        {
          Direction direction_45 = direction.turn(45 * side * -1);
          bool canNotGoDiagonalBefore1 = !grid.leaveAble(wpBefore, direction90) || !grid.leaveAble(wpBefore.go(direction90),  direction_45);
          //bool canNotGoDiagonalBefore2 = !grid.leaveAble(wpBefore, direction135) || !grid.leaveAble(wpBefore.go(direction135), direction);
          //bool canNotGoDiagonalBefore3 = !grid.leaveAble(wpBefore, direction_45) || !grid.leaveAble(wpBefore.go(direction_45), direction90);
          if (side == 1 || canNotGoDiagonalBefore1)
          {
            bool jumpPointAhead = isJumpPoint(position, direction135);
            if (jumpPointAhead)
            {
              jumpDirections.add(direction135);
            }
          }
        }
      }
    }

    return jumpDirections;
  }
}