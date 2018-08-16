import 'Direction.dart';
import 'Position.dart';
import 'Size.dart';
import 'dart:math';

class Distance
{
  int _cardinal;
  int _diagonal;

  Distance(this._cardinal, this._diagonal);

  Distance.calc(Position p1, Position p2)
  {
    int dx = (p1.x - p2.x).abs();
    int dy = (p1.y - p2.y).abs();
    _diagonal = min(dx, dy);
    _cardinal = max(dx, dy) - _diagonal;
  }

  bool operator <(Object other)
  {
    if (other is Distance)
    {
      if (other._cardinal != _cardinal || other._diagonal != _diagonal)
      {
        return _length() < other._length();
      }
      else
      {
        return false;
      }
    }
    else
    {
      assert(false, "other is no Distance: $other");
      return false;
    }
  }

  double _length() => _cardinal + _diagonal * sqrt(2);
}