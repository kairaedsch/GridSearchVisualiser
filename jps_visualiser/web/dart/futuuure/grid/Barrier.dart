import 'Direction.dart';

class Barrier
{
  static const Barrier totalUnblocked = const Barrier(
      const {
        Direction.NORTH: false,
        Direction.NORTH_EAST: false,
        Direction.EAST: false,
        Direction.SOUTH_EAST: false,
        Direction.SOUTH: false,
        Direction.SOUTH_WEST: false,
        Direction.WEST: false,
        Direction.NORTH_WEST: false,
      });

  static const Barrier totalBlocked = const Barrier(
      const {
        Direction.NORTH: true,
        Direction.NORTH_EAST: true,
        Direction.EAST: true,
        Direction.SOUTH_EAST: true,
        Direction.SOUTH: true,
        Direction.SOUTH_WEST: true,
        Direction.WEST: true,
        Direction.NORTH_WEST: true,
      });

  final Map<Direction, bool> blocked;

  const Barrier(this.blocked);

  bool isAnyBlocked() => blocked.values.any((blocked) => blocked);

  bool isNoneBlocked() => !isAnyBlocked();

  void set(Direction directionToTransform, bool shouldBecomeBlocked)
  {
    blocked[directionToTransform] = shouldBecomeBlocked;
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
    return blocked[direction];
  }
}