import '../../../general/geo/Array2D.dart';
import '../../../general/geo/Position.dart';
import '../../../general/geo/Size.dart';
import '../../../general/geo/Direction.dart';
import '../Store.dart';

class GridCache
{
  final Store _store;
  Array2D<Map<Direction, bool>> _grid;

  Size get size => _store.size;

  GridCache(this._store)
  {
    rebuild();
    _store.addEqualListener(["size", "gridMode", "directionMode", "cornerMode", "directionalMode"], rebuild);
    _store.addStartsWithListener(["barrier_"], (ids)
    {
      for (String id in ids)
      {
        Position position = new Position.fromString(id.substring(id.indexOf("(")));
        if (position.legal(size))
        {
          update(position);
        }
      }
    });
  }

  bool leaveAble(Position pos, Direction direction)
  {
    return _grid[pos][direction];
  }

  void rebuild()
  {
    _grid = new Array2D(_store.size, (p) => new Map.fromIterable(Direction.values, value: (dynamic d) => false));
    for (Position position in _store.size.positions())
    {
      _updateOne(position);
    }
  }

  void update(Position position)
  {
    _updateOne(position);
    position.neighbours(_store.size).forEach(_updateOne);
  }

  void _updateOne(Position position)
  {
    for (Direction direction in Direction.values)
    {
      _grid[position][direction] = _store.gridBarrierManager.leaveAble(position, direction);
    }
  }

  Iterable<Position> accessibleNeighbours(Position origin)
  {
    return Direction.values
        .where((Direction direction) => leaveAble(origin, direction))
        .map((Direction direction) => origin.go(direction))
        .where((Position position) => position.legal(size));
  }
}