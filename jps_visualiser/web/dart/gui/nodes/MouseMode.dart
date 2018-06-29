import '../../general/Direction.dart';
import '../../general/Position.dart';
import 'ReactGrid.dart';

abstract class MouseMode
{
  ReactGridComponent _reactGrid;
  ReactGridComponent get reactGrid => _reactGrid;

  MouseMode(this._reactGrid);

  void evaluateNode(Position position);
  void evaluateNodePart(Position position, {Direction direction});
}