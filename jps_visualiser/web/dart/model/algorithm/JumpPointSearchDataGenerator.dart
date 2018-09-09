import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../Grid.dart';
import '../heuristics/Heuristic.dart';
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

    addSearchState();

    PathHighlight pathHighlightGenerator(Position origin, Position position, Direction direction)
    {
      var signpost = data[position].signposts[direction];

      List<Position> path = new List<Position>.generate(signpost.distance + 1, (d) => position.goMulti(direction, d));

      return new PathHighlight.styled(signpost.isWallAhead ? "red" : "green", path, showEnd: true, origin: origin);
    }

    List<PathHighlight> pathHighlightsGenerator(Position origin, Position position, Iterable<Direction> jumpDirections, int depth)
    {
      var highlights = jumpDirections.map((directionInJumpTarget) => pathHighlightGenerator(origin, position, directionInJumpTarget)).toList();

      if (depth > 1)
      {
        highlights.addAll(jumpDirections.expand((direction)
        {
          Position jumpTarget = position.goMulti(direction, data[position].signposts[direction].distance);

          var directionsInJumpTarget = data[jumpTarget].directionAdvisers[direction].jumpDirections;

          return pathHighlightsGenerator(origin, jumpTarget, directionsInJumpTarget, depth - 1);
        }));
      }

      return highlights;
    }

    List<PathHighlight> paths = grid.positions().expand((position) => pathHighlightsGenerator(position, position, Direction.values, 3)).toList();

    currentSearchState.backgroundHighlights.addAll(paths);

    currentSearchState.title..addT("Finished");

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
        recomputeBox(new Position(x, y), direction);
      }
    }
  }

  void recomputeBox(Position position, Direction direction)
  {
    Position prePosition = position.go(direction);

    /*
    currentSearchState.title
      ..addT("Turn $position $direction")
    ;

    currentSearchState.description.add(new Explanation()
      ..addT("We will now calculate whats in the $direction of the node at ")
      ..addH("$position", "yellow", [new CircleHighlight(new Set()..add(position))])
      ..addT(". We therefore have to look at the neighbour node which lays in that direction as we have already calculated its data int that direction.")..addT(" from the ")
    );
    */
    if (!grid.leaveAble(position, direction))
    {
      data[position].signposts[direction].type = JumpPointSearchDataPointDirectionType.WALL;
      data[position].signposts[direction].distance = 0;
    }
    else
    {
      Set<Direction> jumpDirectionsAhead;
      if (direction.isCardinal)
      {
        jumpDirectionsAhead = _cardinalJumpDirections(prePosition, direction);
      }
      else
      {
        jumpDirectionsAhead = _diagonalJumpDirections(prePosition, direction);
      }
      if (jumpDirectionsAhead.length > 0)
      {
        data[position].signposts[direction].type = JumpPointSearchDataPointDirectionType.JUMP_POINT;
        data[prePosition].directionAdvisers[direction].jumpDirections = jumpDirectionsAhead;
        data[position].signposts[direction].distance = 1;
      }
      else
      {
        var preJump = data[prePosition].signposts[direction];

        data[position].signposts[direction].type = preJump.type;
        data[position].signposts[direction].distance = preJump.distance + 1;
      }
    }
    data[position].signposts[direction].generated = true;
  }

  Set<Direction> _cardinalJumpDirections(Position position, Direction direction)
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

  Set<Direction> _diagonalJumpDirections(Position position, Direction direction)
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
        bool jumpPointAhead = data[position].signposts[direction45].isJumpPointAhead;
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
            bool jumpPointAhead = data[position].signposts[direction135].isJumpPointAhead;
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

class JumpPointSearchData extends Array2D<JumpPointSearchDataPoint>
{
  JumpPointSearchData(Size size) : super(size, (_) => new JumpPointSearchDataPoint());
}

class JumpPointSearchDataPoint
{
  final Map<Direction, JumpPointSearchDataSignpost> signposts;
  final Map<Direction, JumpPointSearchDataDirectionAdviser> directionAdvisers;

  JumpPointSearchDataPoint()
      : signposts = new Map.fromIterables(Direction.values, Direction.values.map((_) => new JumpPointSearchDataSignpost())),
        directionAdvisers = new Map.fromIterables(Direction.values, Direction.values.map((_) => new JumpPointSearchDataDirectionAdviser()));
}

class JumpPointSearchDataSignpost
{
  bool generated = false;
  JumpPointSearchDataPointDirectionType type = JumpPointSearchDataPointDirectionType.WALL;
  int distance = 0;

  bool get isWallAhead => type == JumpPointSearchDataPointDirectionType.WALL;

  bool get isJumpPointAhead => type == JumpPointSearchDataPointDirectionType.JUMP_POINT;
}

class JumpPointSearchDataDirectionAdviser
{
  Set<Direction> jumpDirections = new Set();
}

enum JumpPointSearchDataPointDirectionType
{
  WALL, JUMP_POINT
}

enum CountDirection
{
  COUNT_UP, COUNT_DOWN, COUNT_ANY
}