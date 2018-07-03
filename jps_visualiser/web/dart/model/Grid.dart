import '../general/Array2D.dart';
import '../general/Direction.dart';
import '../general/Position.dart';
import '../general/Size.dart';

class Grid implements Size
{
  final Array2D<Node> _grid;

  Grid(int width, int height, Node producer(Position pos))
      : _grid = new Array2D<Node>(width, height, producer);

  bool leaveAble(Position pos, Direction direction)
  {
    return _grid[pos].leaveAble(direction);
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
}

class Node
{
  final Map<Direction, bool> _leaveAble;

  final Position position;

  Node(this.position, bool leaveAble(Direction direction))
      : _leaveAble = new Map<Direction, bool>.fromIterable(Direction.values, key: (direction) => direction, value: leaveAble);


  bool leaveAble(Direction direction) {
    return _leaveAble[direction];
  }

  double distanceTo(Node n)
  {
    return (n.position - position).length();
  }
}