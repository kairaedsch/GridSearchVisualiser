import '../../general/Direction.dart';
import '../../general/Position.dart';

class StructureNode
{
  final StructureNodeType type;

  final Position pos;
  int get x => pos.x;
  int get y => pos.y;

  final StructureNodeBarrier barrier;

  StructureNode(this.pos, this.type, this.barrier);

  StructureNode.normal(this.pos)
      : type = StructureNodeType.NORMAL_NODE,
        barrier = new StructureNodeBarrier();
}

class StructureNodeType
{
  static StructureNodeType SOURCE_NODE = new StructureNodeType("SOURCE_NODE");
  static StructureNodeType TARGET_NODE = new StructureNodeType("TARGET_NODE");
  static StructureNodeType NORMAL_NODE = new StructureNodeType("NORMAL_NODE");

  final String name;
  String toString() => name;

  StructureNodeType(this.name);
}

class StructureNodeBarrier
{
  final Map<Direction, bool> blocked;

  StructureNodeBarrier()
      : blocked = new Map<Direction, bool>.fromIterable(Direction.values,
      key: (direction) => direction,
      value: (direction) => true);
}