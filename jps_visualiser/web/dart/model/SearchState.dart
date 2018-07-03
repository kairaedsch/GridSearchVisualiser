import '../general/Array2D.dart';
import '../general/Position.dart';
import '../general/Size.dart';
import 'NodeSearchState.dart';

class SearchState implements Size
{
  final Array2D<NodeSearchState> grid;

  final int id;

  SearchState(this.id, Size size) :
        grid = new Array2D(size.width, size.height, (Position pos) => new NodeSearchState());

  NodeSearchState operator [](Position pos) => grid[pos];

  @override
  int get width => grid.width;

  @override
  int get height => grid.height;

  Iterable<NodeSearchState> get iterable => grid.iterable;
}