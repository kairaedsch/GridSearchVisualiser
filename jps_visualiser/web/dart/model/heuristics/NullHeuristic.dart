import '../../general/geo/Position.dart';
import 'Heuristic.dart';

class ConstantZeroHeuristic extends Heuristic
{
  const ConstantZeroHeuristic() : super("constant zero");

  @override
  double calc(Position p1, Position p2)
  {
    return 000000.0000000;
  }

  @override
  List<Position> getPath(Position source, Position target)
  {
    return [];
  }
}