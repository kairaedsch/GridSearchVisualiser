import '../general/Array2D.dart';
import '../general/Direction.dart';
import '../general/Distance.dart';
import '../general/Position.dart';
import '../general/Size.dart';

class Grid extends Size
{
  final Array2D<Node> _grid;

  Grid(Size size, Node producer(Position pos))
      : _grid = new Array2D<Node>(size, producer),
        super.clone(size);

  bool leaveAble(Position pos, Direction direction)
  {
    return pos.legal(this) && _grid[pos].leaveAble(direction);
  }

  Iterable<Node> neighbours(Node node)
  {
    return Direction.values
        .where((Direction direction) => node.leaveAble(direction))
        .map((Direction direction) => node.position.go(direction))
        .where((Position position) => position.legal(_grid))
        .map((Position position) => _grid[position]);
  }

  Node operator [](Position pos) => _grid[pos];

  @override
  int get width => _grid.width;

  @override
  int get height => _grid.height;

  Iterable<Node> get iterable => _grid.iterable;
}

class Node
{
  final Map<Direction, bool> _leaveAble;

  final Position position;

  Node(this.position, bool leaveAble(Direction direction))
      : _leaveAble = new Map<Direction, bool>.fromIterable(Direction.values, key: (Direction direction) => direction, value: leaveAble);

  bool leaveAble(Direction direction) {
    return _leaveAble[direction];
  }

  Distance distanceTo(Node n)
  {
    return new Distance.calc(n.position, position);
  }
}