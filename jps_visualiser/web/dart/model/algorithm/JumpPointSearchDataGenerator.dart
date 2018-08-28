import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../Grid.dart';
import '../heuristics/Heuristic.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import 'Algorithm.dart';

class JumpPointSearchDataGenerator extends Algorithm
{
  static AlgorithmFactory factory = (Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic) => new JumpPointSearchDataGenerator(grid, startPosition, targetPosition, heuristic);

  final JumpPointSearchData data;

  JumpPointSearchDataGenerator(Grid grid, Position startPosition, Position targetPosition, Heuristic heuristic)
      : data = new JumpPointSearchData(grid),
        super(grid, startPosition, targetPosition, heuristic);

  @override
  void runInner()
  {
    _computeAllCardinal();
    _computeAllDiagonal();

    searchHistory.title = "Generated JPS Data";
  }

  void _computeAllCardinal()
  {
    computeBoxes(CountDirection.COUNT_UP, CountDirection.COUNT_ANY, Direction.WEST);
    computeBoxes(CountDirection.COUNT_DOWN, CountDirection.COUNT_ANY, Direction.EAST);
    computeBoxes(CountDirection.COUNT_ANY, CountDirection.COUNT_UP, Direction.NORTH);
    computeBoxes(CountDirection.COUNT_ANY, CountDirection.COUNT_DOWN, Direction.SOUTH);
  }

  void _computeAllDiagonal()
  {
    computeBoxes(CountDirection.COUNT_UP, CountDirection.COUNT_UP, Direction.NORTH_WEST);
    computeBoxes(CountDirection.COUNT_DOWN, CountDirection.COUNT_UP, Direction.NORTH_EAST);
    computeBoxes(CountDirection.COUNT_DOWN, CountDirection.COUNT_DOWN, Direction.SOUTH_EAST);
    computeBoxes(CountDirection.COUNT_UP, CountDirection.COUNT_DOWN, Direction.SOUTH_WEST);
  }

  void computeBoxes(CountDirection countDirectionX, CountDirection countDirectionY, Direction direction)
  {
    int deltaX = (countDirectionX == CountDirection.COUNT_UP) ? 1 : -1;
    int deltaY = (countDirectionY == CountDirection.COUNT_UP) ? 1 : -1;

    int startX = (countDirectionX == CountDirection.COUNT_UP) ? 0 : (grid.width - 1);
    int startY = (countDirectionY == CountDirection.COUNT_UP) ? 0 : (grid.height - 1);

    for (int y = startY; (countDirectionY == CountDirection.COUNT_UP) ? y < grid.height : y >= 0; y += deltaY)
    {
      for (int x = startX; (countDirectionX == CountDirection.COUNT_UP) ? x < grid.width : x >= 0; x += deltaX)
      {
        addSearchState();

        List<PathHighlight> paths = grid.positions()
            .expand((position) =>
            Direction.values.map((direction)
            {
              var dataPointDirection = data[position][direction];

              if (!dataPointDirection.generated || dataPointDirection.isWallAhead)
              {
                return null;
              }

              List<Position> path = new List<Position>.generate(dataPointDirection.distance + 1, (d) => position.goMulti(direction, d));

              return new PathHighlight.styled(dataPointDirection.isWallAhead ? "red" : "green", path, showEnd: true);
            })).toList();

        currentSearchState.backgroundHighlights.addAll(paths);

        recomputeBox(new Position(x, y), direction);
      }
    }
  }

  void recomputeBox(Position position, Direction direction)
  {
    currentSearchState.title
      ..addT("Turn $position $direction")
    ;

    Position prePosition = position.go(direction);

    currentSearchState.description.add(new Explanation()
      ..addT("We will now calculate whats in the $direction of the node at ")
      ..addH("$position", "yellow", [new CircleHighlight(new Set()..add(position))])
      ..addT(". We therefore have to look at the neighbour node which lays in that direction as we have already calculated its data int that direction.")
      ..addT(" from the ")
    );

    if (!grid.leaveAble(position, direction))
    {
      currentSearchState.description.last
        ..addT("But all these nodes already have an good path. ")
      ;

      data[position][direction].type = JumpPointSearchDataPointDirectionType.WALL;
      data[position][direction].distance = 0;
    }
    else
    {
      bool jumpPointPointAhead;
      if (direction.isCardinal)
      {
        jumpPointPointAhead = _isCardinalJumpPoint(prePosition, direction);
      }
      else
      {
        bool leftJumpPointAhead = data[prePosition][direction.turn(-45)].isJumpPointAhead;
        bool rightJumpPointAhead = data[prePosition][direction.turn(45)].isJumpPointAhead;
        jumpPointPointAhead = leftJumpPointAhead || rightJumpPointAhead;
      }
      if (jumpPointPointAhead)
      {
        data[position][direction].type = JumpPointSearchDataPointDirectionType.JUMP_POINT;
        data[position][direction].distance = 1;
      }
      else
      {
        var preJump = data[prePosition][direction];
        data[position][direction].type = preJump.type;
        data[position][direction].distance = preJump.distance + 1;
      }
    }
    data[position][direction].generated = true;
  }

  bool _isCardinalJumpPoint(Position wp, Direction direction)
  {
    Position wpBefore = wp.go(direction.turn(180));

    if (!grid.leaveAble(wpBefore, direction))
    {
      return false;
    }

    Direction direction90 = direction.turn(90);
    if (grid.leaveAble(wp, direction90))
    {
      bool canNotGoDiagonalBefore = !grid.leaveAble(wpBefore, direction.turn(45));
      if (canNotGoDiagonalBefore)
      {
        bool canNotGoCardinalBefore = !grid.leaveAble(wp.go(direction.turn(135)), direction) || !grid.leaveAble(wpBefore, direction90);
        if (canNotGoCardinalBefore)
        {
          return true;
        }
      }
    }

    Direction directionMinus90 = direction.turn(-90);
    if (grid.leaveAble(wp, directionMinus90))
    {
      bool canNotGoDiagonalBefore = !grid.leaveAble(wpBefore, direction.turn(-45));
      if (canNotGoDiagonalBefore)
      {
        bool canNotGoCardinalBefore = !grid.leaveAble(wp.go(direction.turn(-135)), direction) || !grid.leaveAble(wpBefore, directionMinus90);
        if (canNotGoCardinalBefore)
        {
          return true;
        }
      }
    }

    return false;
  }
}

class JumpPointSearchData extends Array2D<JumpPointSearchDataPoint>
{
  JumpPointSearchData(Size size) : super(size, (_) => new JumpPointSearchDataPoint());
}

class JumpPointSearchDataPoint
{
  final Map<Direction, JumpPointSearchDataPointDirection> directions;

  JumpPointSearchDataPoint()
      : directions = new Map.fromIterables(Direction.values, Direction.values.map((_) => new JumpPointSearchDataPointDirection()));

  JumpPointSearchDataPointDirection operator [](Direction direction) => directions[direction];
}

class JumpPointSearchDataPointDirection
{
  bool generated = false;
  JumpPointSearchDataPointDirectionType type = JumpPointSearchDataPointDirectionType.WALL;
  int distance = 0;

  bool get isWallAhead => type == JumpPointSearchDataPointDirectionType.WALL;

  bool get isJumpPointAhead => type == JumpPointSearchDataPointDirectionType.JUMP_POINT;
}

enum JumpPointSearchDataPointDirectionType
{
  WALL, JUMP_POINT
}

enum CountDirection
{
  COUNT_UP, COUNT_DOWN, COUNT_ANY
}