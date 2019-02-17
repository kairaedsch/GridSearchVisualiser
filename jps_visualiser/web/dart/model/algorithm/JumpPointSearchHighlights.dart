import '../../general/geo/Position.dart';
import '../history/Highlight.dart';
import '../../general/geo/Direction.dart';

class DirectedJumpPointSearchHighlights
{
  static Iterable<Highlight> forcedDirections(Position jumpPoint, Iterable<Direction> directions)
  {
    return directions.expand((direction)
    {
      return forcedDirection(jumpPoint, direction);
    });
  }

  static Iterable<Highlight> forcedDirection(Position jumpPoint, Direction direction)
  {
    return [new PathHighlight.styled("green dotted", [jumpPoint, jumpPoint.go(direction)], showEnd: true)];
  }

  static Iterable<Highlight> recursiveStep(Position node, Direction direction, bool success)
  {
    return [new PathHighlight.styled(success ? "green" : "red", [node, node.go(direction)], showEnd: true)];
  }
}