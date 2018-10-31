import '../../general/geo/Position.dart';

abstract class Heuristic
{
  final String _name;

  const Heuristic(this._name);

  double calc(Position p1, Position p2);

  List<Position> getPath(Position source, Position target);

  @override
  String toString() => _name;
}