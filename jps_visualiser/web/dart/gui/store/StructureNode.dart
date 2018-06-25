import '../../general/Direction.dart';
import '../../general/Position.dart';

class StructureNode
{
  final StructureNodeType type;

  final Position pos;

  int get x => pos.x;

  int get y => pos.y;

  final StructureNodeBarrier barrier;

  const StructureNode(this.pos, this.type, this.barrier);

  StructureNode.normal(this.pos)
      : type = StructureNodeType.NORMAL_NODE,
        barrier = StructureNodeBarrier.totalUnblocked;

  StructureNode clone({StructureNodeType type, StructureNodeBarrier barrier})
  {
    if (type == null) type = this.type;
    if (barrier == null) barrier = this.barrier;

    return new StructureNode(pos, type, barrier);
  }
}

class StructureNodeType
{
  static const StructureNodeType SOURCE_NODE = const StructureNodeType("SOURCE_NODE");
  static const StructureNodeType TARGET_NODE = const StructureNodeType("TARGET_NODE");
  static const StructureNodeType NORMAL_NODE = const StructureNodeType("NORMAL_NODE");

  final String name;

  String toString() => name;

  const StructureNodeType(this.name);

  static const List<StructureNodeType> values = const <StructureNodeType>[
    SOURCE_NODE, TARGET_NODE, NORMAL_NODE];
}

class StructureNodeBarrier
{
  static const StructureNodeBarrier totalUnblocked = const StructureNodeBarrier(
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

  static const StructureNodeBarrier totalBlocked = const StructureNodeBarrier(
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

  const StructureNodeBarrier(this.blocked);

  StructureNodeBarrier.cloneAndTransform(StructureNodeBarrier barrier, Direction directionToTransform, bool shouldBecomeBlocked)
      : blocked = new Map<Direction, bool>.fromIterable(barrier.blocked.keys,
      key: (direction) => direction,
      value: (direction) => direction == directionToTransform ? shouldBecomeBlocked : barrier.blocked[direction]);

  bool isAnyBlocked() => blocked.values.any((blocked) => blocked);

  StructureNodeBarrier transformTo(Direction directionToTransform, bool shouldBecomeBlocked)
  {
    return new StructureNodeBarrier.cloneAndTransform(this, directionToTransform, shouldBecomeBlocked);
  }

  StructureNodeBarrier transformToTotal(bool shouldBecomeBlocked)
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