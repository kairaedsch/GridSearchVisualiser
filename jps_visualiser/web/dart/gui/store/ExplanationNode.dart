import '../../general/Position.dart';

class ExplanationNode
{
  final ExplanationMarking marking;

  final Position pos;
  int get x => pos.x;
  int get y => pos.y;

  ExplanationNode(this.pos, this.marking);

  ExplanationNode.normal(this.pos)
        : marking = ExplanationMarking.Unmarked;
}

enum ExplanationMarking
{
  Closed, Open, Unmarked
}