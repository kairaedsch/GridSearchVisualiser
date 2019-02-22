import '../../../general/geo/Direction.dart';

class Barrier
{
  static Barrier get totalUnblocked => new Barrier(
      {
        Direction.NORTH: false,
        Direction.NORTH_EAST: false,
        Direction.EAST: false,
        Direction.SOUTH_EAST: false,
        Direction.SOUTH: false,
        Direction.SOUTH_WEST: false,
        Direction.WEST: false,
        Direction.NORTH_WEST: false,
      });

  static Barrier get totalBlocked => new Barrier(
      {
        Direction.NORTH: true,
        Direction.NORTH_EAST: true,
        Direction.EAST: true,
        Direction.SOUTH_EAST: true,
        Direction.SOUTH: true,
        Direction.SOUTH_WEST: true,
        Direction.WEST: true,
        Direction.NORTH_WEST: true,
      });

  final Map<Direction, bool> _blocked;

  const Barrier(this._blocked);

  Barrier.fromMap(Map map)
    : _blocked = new Map<Direction, bool>.fromIterables(map.keys.map((dynamic d) => Direction.values[int.parse(d as String)]), map.values.map((dynamic d) => d as bool).toList());

  bool isAnyBlocked() => _blocked.values.any((blocked) => blocked);

  bool isNoneBlocked() => !isAnyBlocked();

  void set(Direction directionToTransform, bool shouldBecomeBlocked)
  {
    _blocked[directionToTransform] = shouldBecomeBlocked;
  }

  Barrier transformToTotal(bool shouldBecomeBlocked)
  {
    if (isAnyBlocked())
    {
      return shouldBecomeBlocked ? this : totalUnblocked;
    }
    else
    {
      return shouldBecomeBlocked ? totalBlocked : this;
    }
  }

  bool isBlocked(Direction direction)
  {
    return _blocked[direction];
  }

  Map toMap() => new Map<String, bool>.fromIterables(_blocked.keys.map((d) => "${d.index}"), _blocked.values);
}