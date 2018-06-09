import '../../general/Position.dart';

class Node
{
  final NodeType type;
  final NodeMarking marking;

  final Position pos;
  int get x => pos.x;
  int get y => pos.y;

  Node(this.pos, this.type, this.marking);

  Node.normal(this.pos)
      : type = NodeType.NormalNode,
        marking = NodeMarking.Unmarked;
}

enum NodeType
{
  SourceNode, TargetNode, NormalNode
}

enum NodeMarking
{
  Closed, Open, Unmarked
}