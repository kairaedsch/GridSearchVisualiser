import '../../general/Position.dart';
import 'Heuristic.dart';

class Manhattan implements Heuristic
{
  const Manhattan();

  @override
  double calculateApproximateDistance(Position p1, Position p2)
  {
    return 0.0 + (p1.x - p2.x).abs() + (p1.y - p2.y).abs();
  }
}
