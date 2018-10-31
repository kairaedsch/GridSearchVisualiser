import 'Position.dart';
import 'dart:math';

class Distance
{
  static Distance INFINITY = new Distance(pow(2, 53) as int, pow(2, 53) as int);

  int _cardinal;
  int get cardinal => _cardinal;

  int _diagonal;
  int get diagonal => _diagonal;

  Distance(this._cardinal, this._diagonal);

  Distance.calc(Position p1, Position p2)
  {
    int dx = (p1.x - p2.x).abs();
    int dy = (p1.y - p2.y).abs();
    _diagonal = min(dx, dy);
    _cardinal = max(dx, dy) - _diagonal;
  }

  Distance operator -(Distance other) => new Distance(_cardinal - other._cardinal, _diagonal - other._diagonal);

  Distance operator +(Distance other) => new Distance(_cardinal + other._cardinal, _diagonal + other._diagonal);

  Distance operator *(int scale) => new Distance(_cardinal * scale, _diagonal * scale);

  bool operator <(Distance other)
  {
    if (other._cardinal != _cardinal || other._diagonal != _diagonal)
    {
      return length() < other.length();
    }
    else
    {
      return false;
    }
  }

  double length() => _cardinal + _diagonal * sqrt(2);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Distance &&
          _cardinal == other._cardinal &&
          _diagonal == other._diagonal;

  @override
  int get hashCode =>
      _cardinal.hashCode ^
      _diagonal.hashCode;
}