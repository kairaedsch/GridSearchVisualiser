import '../../general/geo/Array2D.dart';
import '../../general/geo/Position.dart';
import '../../general/geo/Size.dart';
import '../store/GridCache.dart';
import '../grid/Direction.dart';
import '../heuristics/Heuristic.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import 'Algorithm.dart';
import 'JumpPointSearchJumpPoints.dart';
import 'package:tuple/tuple.dart';

class JumpPointSearchPlusDataGenerator extends Algorithm
{
  static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new JumpPointSearchPlusDataGenerator(grid, startPosition, targetPosition, heuristic, turnOfHistory);

  final JumpPointSearchData data;

  JumpPointSearchPlusDataGenerator(GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory)
      : data = new JumpPointSearchData(grid.size),
        super(grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {
    _computeAllCardinal();
    _computeAllDiagonal();

    tunIsOver();
    if (createHistory())
    {
      searchHistory.stepTitle = "Interaktive arrows";

      searchHistory..newExplanation(new Explanation())
        ..addES_("<The JPS+ Data Algorithm is working but the explanation for it has not been implemented yet>");

      Tuple2<Iterable<Highlight>, Iterable<Position>> pathHighlightGenerator(Position origin, Position position, Direction direction)
      {
        var signpost = data[position].signposts[direction];

        List<Position> path = new List<Position>.generate(signpost.distance + 1, (d) => position.goMulti(direction, d));

        return new Tuple2([new PathHighlight.styled(signpost.isWallAhead ? "red" : "green", path, showEnd: true)], [origin]);
      }

      List<Tuple2<Iterable<Highlight>, Iterable<Position>>> pathHighlightsGenerator(Position origin, Position position, Iterable<Direction> jumpDirections, int depth)
      {
        var highlights = jumpDirections.map((directionInJumpTarget) => pathHighlightGenerator(origin, position, directionInJumpTarget)).toList();

        if (depth > 1)
        {
          highlights.addAll(jumpDirections.expand((direction)
          {
            Position jumpTarget = position.goMulti(direction, data[position].signposts[direction].distance);

            var directionsInJumpTarget = [direction]..addAll(data[jumpTarget].directionAdvisers[direction].jumpDirections);

            return pathHighlightsGenerator(origin, jumpTarget, directionsInJumpTarget, depth - 1);
          }));
        }

        return highlights;
      }

      List<Tuple2<Iterable<Highlight>, Iterable<Position>>> paths = grid.size.positions().expand((position) => pathHighlightsGenerator(position, position, Direction.values, 3)).toList();

      searchHistory.addHM("background", paths);
    }

    tunIsOver();
    if (createHistory())
    {
      searchHistory.stepTitle = "Static arrows";

      searchHistory..newExplanation(new Explanation())
        ..addES_("<The JPS+ Data Algorithm is working but the explanation for it has not been implemented yet>");

      List<PathHighlight> paths = grid.size
          .positions()
          .expand((position) =>
          Direction.values.map((direction)
          {
            var dataPointDirection = data[position].signposts[direction];

            if (dataPointDirection.isWallAhead)
            {
              return null;
            }

            List<Position> path = new List<Position>.generate(dataPointDirection.distance + 1, (d) => position.goMulti(direction, d));

            return new PathHighlight.styled(dataPointDirection.isWallAhead ? "red" : (dataPointDirection.isIntermediateJumpPointAhead ? "yellow" : "green"), path, showEnd: true);
          })).toList();

      searchHistory.addH_("background", paths, [null]);
    }

    tunIsOver();
    if (createHistory())
    {
      searchHistory.stepTitle = "Static numbers";

      searchHistory..newExplanation(new Explanation())
        ..addES_("<The JPS+ Data Algorithm is working but the explanation for it has not been implemented yet>");

      List<Tuple2<Iterable<Highlight>, Iterable<Position>>> texts = grid.size
          .positions()
          .expand((position) =>
          Direction.values.map((direction)
          {
            var dataPointDirection = data[position].signposts[direction];

            return new Tuple2([new DirectionTextHighlight.styled(dataPointDirection.isWallAhead ? "red" : (dataPointDirection.isIntermediateJumpPointAhead ? "yellow" : "green"), "${dataPointDirection.distance}", direction)], [position]);
          })).toList();

      searchHistory.addHM("background", texts);
    }

    searchHistory.title = "Generated JPS+ Data";
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

    int startX = (countDirectionX == CountDirection.COUNT_UP) ? 0 : (grid.size.width - 1);
    int startY = (countDirectionY == CountDirection.COUNT_UP) ? 0 : (grid.size.height - 1);

    for (int y = startY; (countDirectionY == CountDirection.COUNT_UP) ? y < grid.size.height : y >= 0; y += deltaY)
    {
      for (int x = startX; (countDirectionX == CountDirection.COUNT_UP) ? x < grid.size.width : x >= 0; x += deltaX)
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
      if (Directions.isCardinal(direction))
      {
        jumpDirectionsAhead = JumpPointSearchJumpPoints.cardinalJumpDirections(grid, prePosition, direction);
      }
      else
      {
        jumpDirectionsAhead = JumpPointSearchJumpPoints.diagonalJumpDirections(grid, prePosition, direction, (position, direction) => data[position].signposts[direction].isJumpPointAhead);
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

        /*if (preJump.distance >= 3 && (position.x % 3 == 0 || position.y % 3 == 0) && direction.isDiagonal)
        {
          data[position].signposts[direction].type = JumpPointSearchDataPointDirectionType.INTERMEDIATE_JUMP_POINT;
          data[position].signposts[direction].distance = 1;
        }
        else*/
        {
          data[position].signposts[direction].type = preJump.type;
          data[position].signposts[direction].distance = preJump.distance + 1;
        }
      }
    }
    data[position].signposts[direction].generated = true;
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

  bool get isJumpPointAhead => type == JumpPointSearchDataPointDirectionType.JUMP_POINT || type == JumpPointSearchDataPointDirectionType.INTERMEDIATE_JUMP_POINT;

  bool get isIntermediateJumpPointAhead => type == JumpPointSearchDataPointDirectionType.INTERMEDIATE_JUMP_POINT;
}

class JumpPointSearchDataDirectionAdviser
{
  Set<Direction> jumpDirections = new Set();
}

enum JumpPointSearchDataPointDirectionType
{
  WALL, JUMP_POINT, INTERMEDIATE_JUMP_POINT
}

enum CountDirection
{
  COUNT_UP, COUNT_DOWN, COUNT_ANY
}