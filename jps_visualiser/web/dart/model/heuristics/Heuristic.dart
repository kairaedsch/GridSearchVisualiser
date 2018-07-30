import '../../general/Position.dart';
import '../Grid.dart';

abstract class Heuristic
{
  final String _name;

  const Heuristic(this._name);

  double calc(Node n1, Node n2)
  {
    return calcP(n1.position, n2.position);
  }

  double calcP(Position p1, Position p2);

  List<Position> getPath(Node source, Node target)
  {
    return getPathP(source.position, target.position);
  }

  List<Position> getPathP(Position source, Position target);

  @override
  String toString() => _name;
}