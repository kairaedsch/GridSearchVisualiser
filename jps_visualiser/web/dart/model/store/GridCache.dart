import '../../general/geo/Array2D.dart';
import '../../general/geo/Position.dart';
import '../../general/geo/Size.dart';
import '../grid/Direction.dart';
import 'Store.dart';

class GridCache
{
  final Store _store;
  final Array2D<Map<Direction, bool>> _grid;

  Size get size => _store.size;

  GridCache(this._store)
      : _grid = new Array2D(_store.size, (p) => new Map.fromIterable(Direction.values, value: (Direction d) => false))
  {
    _store.addEqualListener(["size", "gridMode", "directionMode", "cornerMode", "directionalMode"], rebuild);
    _store.addStartsWithListener(["barrier_"], (ids)
    {
      for (String id in ids)
      {
        Position position = new Position.fromString(id.substring(id.indexOf("(")));
        update(position);
      }
    });
    rebuild();
  }

  bool leaveAble(Position pos, Direction direction)
  {
    return _grid[pos][direction];
  }

  void rebuild()
  {
    for (Position position in _store.size.positions())
    {
      _updateOne(position);
    }
  }

  void update(Position position)
  {
    _updateOne(position);
    neighbours(position).forEach(_updateOne);
  }

  void _updateOne(Position position)
  {
    for (Direction direction in Direction.values)
    {
      _grid[position][direction] = _store.gridBarrierManager.leaveAble(position, direction);
    }
  }

  Iterable<Position> neighbours(Position origin)
  {
    return Direction.values
        .where((Direction direction) => leaveAble(origin, direction))
        .map((Direction direction) => origin.go(direction))
        .where((Position position) => position.legal(size));
  }
}