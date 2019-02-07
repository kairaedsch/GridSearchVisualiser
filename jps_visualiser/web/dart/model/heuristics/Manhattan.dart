import '../../general/geo/Position.dart';
import 'Heuristic.dart';

class Manhattan extends Heuristic
{
  const Manhattan(): super("Manhattan distance");

  @override
  double calc(Position p1, Position p2)
  {
    return 0.0 + (p1.x - p2.x).abs() + (p1.y - p2.y).abs();
  }

  @override
  List<Position> getPath(Position source, Position target)
  {
    List<Position> path = [source];
    while (path.last.x != target.x)
    {
      path.add(new Position(path.last.x + (path.last.x > target.x ? -1 : 1), path.last.y));
    }
    while (path.last.y != target.y)
    {
      path.add(new Position(path.last.x, path.last.y + (path.last.y > target.y ? -1 : 1)));
    }
    return path;
  }
}
