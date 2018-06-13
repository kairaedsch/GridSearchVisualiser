import '../../general/Position.dart';

class ExplanationNode
{
  final ExplanationMarking marking;

  final Position pos;
  int get x => pos.x;
  int get y => pos.y;

  ExplanationNode(this.pos, this.marking);

  ExplanationNode.normal(this.pos)
        : marking = ExplanationMarking.UNMARKED;
}

class ExplanationMarking
{
  static const ExplanationMarking CLOSED = const ExplanationMarking("CLOSED");
  static const ExplanationMarking OPEN = const ExplanationMarking("OPEN");
  static const ExplanationMarking UNMARKED = const ExplanationMarking("UNMARKED");

  final String name;
  String toString() => name;

  const ExplanationMarking(this.name);

  static const List<ExplanationMarking> values = const <ExplanationMarking>[
    CLOSED, OPEN, UNMARKED];
}