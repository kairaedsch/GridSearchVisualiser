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

class ExplanationMarking
{
  static const ExplanationMarking Closed = const ExplanationMarking("Closed");
  static const ExplanationMarking Open = const ExplanationMarking("Open");
  static const ExplanationMarking Unmarked = const ExplanationMarking("Unmarked");

  final String name;
  String toString() => name;

  const ExplanationMarking(this.name);

  static const List<ExplanationMarking> values = const <ExplanationMarking>[
    Closed, Open, Unmarked];
}