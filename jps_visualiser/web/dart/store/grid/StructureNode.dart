import '../../general/Direction.dart';

class StructureNode
{
  final StructureNodeType type;

  final StructureNodeBarrier barrier;

  const StructureNode(this.type, this.barrier);

  StructureNode.normal()
      : type = StructureNodeType.NORMAL_NODE,
        barrier = StructureNodeBarrier.totalUnblocked;

  StructureNode clone({StructureNodeType type, StructureNodeBarrier barrier})
  {
    if (type == null) type = this.type;
    if (barrier == null) barrier = this.barrier;

    return new StructureNode(type, barrier);
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
        DirectionOLD.NORTH: false,
        DirectionOLD.NORTH_EAST: false,
        DirectionOLD.EAST: false,
        DirectionOLD.SOUTH_EAST: false,
        DirectionOLD.SOUTH: false,
        DirectionOLD.SOUTH_WEST: false,
        DirectionOLD.WEST: false,
        DirectionOLD.NORTH_WEST: false,
      });

  static const StructureNodeBarrier totalBlocked = const StructureNodeBarrier(
      const {
        DirectionOLD.NORTH: true,
        DirectionOLD.NORTH_EAST: true,
        DirectionOLD.EAST: true,
        DirectionOLD.SOUTH_EAST: true,
        DirectionOLD.SOUTH: true,
        DirectionOLD.SOUTH_WEST: true,
        DirectionOLD.WEST: true,
        DirectionOLD.NORTH_WEST: true,
      });

  final Map<DirectionOLD, bool> blocked;

  const StructureNodeBarrier(this.blocked);

  StructureNodeBarrier.cloneAndTransform(StructureNodeBarrier barrier, DirectionOLD directionToTransform, bool shouldBecomeBlocked)
      : blocked = new Map<DirectionOLD, bool>.fromIterable(barrier.blocked.keys,
      key: (DirectionOLD direction) => direction,
      value: (DirectionOLD direction) => direction == directionToTransform ? shouldBecomeBlocked : barrier.blocked[direction]);

  bool isAnyBlocked() => blocked.values.any((blocked) => blocked);

  bool isNoneBlocked() => !isAnyBlocked();

  StructureNodeBarrier transformTo(DirectionOLD directionToTransform, bool shouldBecomeBlocked)
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

  bool isBlocked(DirectionOLD direction)
  {
    return blocked[direction];
  }
}