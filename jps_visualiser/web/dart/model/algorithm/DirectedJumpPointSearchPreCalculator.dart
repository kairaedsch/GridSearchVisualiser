import '../../general/geo/Array2D.dart';
import '../../general/geo/Position.dart';
import '../../general/geo/Size.dart';
import '../store/grid/GridCache.dart';
import '../../general/geo/Direction.dart';
import '../heuristics/Heuristic.dart';
import '../history/Explanation.dart';
import '../history/Highlight.dart';
import 'Algorithm.dart';
import 'JumpPointSearchJumpPoints.dart';
import 'package:tuple/tuple.dart';

class DirectedJumpPointSearchPreCalculator extends Algorithm
{
  static AlgorithmFactory factory = (GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory) => new DirectedJumpPointSearchPreCalculator(grid, startPosition, targetPosition, heuristic, turnOfHistory);

  final DirectedJumpPointSearchData data;

  DirectedJumpPointSearchPreCalculator(GridCache grid, Position startPosition, Position targetPosition, Heuristic heuristic, int turnOfHistory)
      : data = new DirectedJumpPointSearchData(grid.size),
        super(grid, startPosition, targetPosition, heuristic, turnOfHistory);

  @override
  void runInner()
  {
    _computeAllCardinal();
    _computeAllDiagonal();

    tunIsOver();
    if (createHistory())
    {
      searchHistory.stepTitle = "Lookup Data - Next Points of Interest - Interaktive Arrow Visualisation";

      searchHistory..newExplanation(new Explanation())
        ..addES_("Here one can view the pre-calculated next jump points of each node. ")
        ..addES_("By hovering with the mouse over a node, green arrows will point to the next jump point of each direction. ")
        ..addES_("Red arrows are shown, when there is no next jump point but only a obstacle. ");

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

      List<Tuple2<Iterable<Highlight>, Iterable<Position>>> paths = grid.size.positions().expand((position) => pathHighlightsGenerator(position, position, Direction.values, 1)).toList();

      searchHistory.addHM("background", paths);
    }

    tunIsOver();
    if (createHistory())
    {
      searchHistory.stepTitle = "Lookup Data - Next Points of Interest - Number Visualisation";

      List<Tuple2<Iterable<Highlight>, Iterable<Position>>> getNumberHighlights(bool where(DirectedJumpPointSearchDataSignpost d))
      {
        return grid.size
          .positions()
          .expand((position) =>
          Direction.values
            .where((direction) => where(data[position].signposts[direction]))
            .map((direction)
          {
            var dataPointDirection = data[position].signposts[direction];

            return new Tuple2([new DirectionTextHighlight.styled(dataPointDirection.isWallAhead ? "red" : (dataPointDirection.isIntermediateJumpPointAhead ? "yellow" : "green"), "${dataPointDirection.distance}", direction)], [position]);
          })).toList();
      }

      searchHistory..newExplanation(new Explanation())
        ..addES_("Here one can view the pre-calculated next jump points of each node. ")
        ..addEM_("Green numbers", "green", getNumberHighlights((dataPointDirection) => !dataPointDirection.isWallAhead))
        ..addES_(" show the distance of the next jump point in a direction. ")
        ..addEM_("Red numbers", "red", getNumberHighlights((dataPointDirection) => dataPointDirection.isWallAhead))
        ..addES_(" are shown, when there is no next jump point in that direction but only a obstacle. ")
        ..addES_("The direction of a number is relative to its position such that for instance a number in the bottom center of a node points south. ")
        ..addES_("In my thesis and in the implementation, the green and red numbers were not distingished by colors but by making the red numbers negative. ");

      searchHistory.addHM("foreground", getNumberHighlights((d) => true));
    }

    tunIsOver();
    if (createHistory())
    {
      searchHistory.stepTitle = "Lookup Data - Forced Directions - Arrow Visualisation";

      Iterable<Highlight> getForcedDirectionsHighlights(List<Direction> sourceDirections)
      {
        return grid.size
          .positions()
          .expand((position) =>
          sourceDirections.expand((direction)
          {
            var directionAdvisers = data[position].directionAdvisers[direction];

            if (directionAdvisers.jumpDirections.isEmpty)
            {
              return const <PathHighlight>[];
            }

            List<PathHighlight> forcedDirections = directionAdvisers.jumpDirections.map((d) => new PathHighlight.styled("green dotted", [position, position.go(d)], showEnd: true, startIntermediate: 0.0, endIntermediate: Directions.isDiagonal(d) ? 3.0 : 2.0)).toList();

            return [new PathHighlight.styled("black", [position.go(Directions.turn(direction, 180)), position], showEnd: true, startIntermediate: Directions.isDiagonal(direction) ? 3.0 : 2.0, endIntermediate: 0.0)]..addAll(forcedDirections);
          })).toList();
      }

      searchHistory..newExplanation(new Explanation())
        ..addES_("At this view you can view the pre-calculated forced directions of each node. ")
        ..addES_("Forced directions are shown as green dotted arrows with black arrows as their source direction. ")
        ..addES_("Because the arrows tend to overlap each other, one can also only display the forced direction of one source direction: ");

      for (Direction direction in Direction.values)
      {
        searchHistory..newExplanation(new Explanation())
          ..addES_("For the ")
          ..addEMS("${Directions.getName(direction)} direction", "green", getForcedDirectionsHighlights([direction]), null)
          ..addES_(".");
      }

      searchHistory.addH_("foreground", getForcedDirectionsHighlights(Direction.values), [null]);
    }

    searchHistory.stepCount = nextTurn;
    searchHistory.title = "Pre-Calculated DJPS Lookup Data";
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
      data[position].signposts[direction].type = DirectedJumpPointSearchDataPointDirectionType.WALL;
      data[position].signposts[direction].distance = 0;
    }
    else
    {
      Set<Direction> jumpDirectionsAhead = DirectedJumpPointSearchJumpPoints.jumpDirections(grid, prePosition, direction, (position, direction) => data[position].signposts[direction].isJumpPointAhead, true);

      if (jumpDirectionsAhead.length > 0)
      {
        data[position].signposts[direction].type = DirectedJumpPointSearchDataPointDirectionType.JUMP_POINT;
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

class DirectedJumpPointSearchData extends Array2D<DirectedJumpPointSearchDataPoint>
{
  DirectedJumpPointSearchData(Size size) : super(size, (_) => new DirectedJumpPointSearchDataPoint());
}

class DirectedJumpPointSearchDataPoint
{
  final Map<Direction, DirectedJumpPointSearchDataSignpost> signposts;
  final Map<Direction, DirectedJumpPointSearchDataDirectionAdviser> directionAdvisers;

  DirectedJumpPointSearchDataPoint()
      : signposts = new Map.fromIterables(Direction.values, Direction.values.map((_) => new DirectedJumpPointSearchDataSignpost())),
        directionAdvisers = new Map.fromIterables(Direction.values, Direction.values.map((_) => new DirectedJumpPointSearchDataDirectionAdviser()));
}

class DirectedJumpPointSearchDataSignpost
{
  bool generated = false;
  DirectedJumpPointSearchDataPointDirectionType type = DirectedJumpPointSearchDataPointDirectionType.WALL;
  int distance = 0;

  bool get isWallAhead => type == DirectedJumpPointSearchDataPointDirectionType.WALL;

  bool get isJumpPointAhead => type == DirectedJumpPointSearchDataPointDirectionType.JUMP_POINT || type == DirectedJumpPointSearchDataPointDirectionType.INTERMEDIATE_JUMP_POINT;

  bool get isIntermediateJumpPointAhead => type == DirectedJumpPointSearchDataPointDirectionType.INTERMEDIATE_JUMP_POINT;
}

class DirectedJumpPointSearchDataDirectionAdviser
{
  Set<Direction> jumpDirections = new Set();
}

enum DirectedJumpPointSearchDataPointDirectionType
{
  WALL, JUMP_POINT, INTERMEDIATE_JUMP_POINT
}

enum CountDirection
{
  COUNT_UP, COUNT_DOWN, COUNT_ANY
}