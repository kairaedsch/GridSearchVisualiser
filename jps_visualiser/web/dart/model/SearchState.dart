import '../general/Array2D.dart';
import '../general/Position.dart';
import '../general/Size.dart';
import 'NodeSearchState.dart';

class SearchState implements Size
{
  final Array2D<NodeSearchState> _grid;
  final int id;
  String title;
  Position activeNodeInTurn;

  SearchState(this.id, Size size) :
        _grid = new Array2D(size, (Position pos) => new NodeSearchState());

  NodeSearchState operator [](Position pos) => _grid[pos];

  @override
  int get width => _grid.width;

  @override
  int get height => _grid.height;

  Iterable<NodeSearchState> get iterable => _grid.iterable;
}