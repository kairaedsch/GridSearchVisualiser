import '../../futuuure/grid/Direction.dart';
import '../../futuuure/transfer/Data.dart';
import '../../general/Position.dart';
import 'ReactGrid.dart';

abstract class MouseMode
{
  ReactGridComponent _reactGrid;
  ReactGridComponent get reactGrid => _reactGrid;

  Data get data => reactGrid.props.data;

  String get name;

  MouseMode(this._reactGrid);

  void evaluateNode(Position position);
  void evaluateNodePart(Position position, {Direction direction});

  StructureNodeType getStructureNodeType(Position position)
  {
    if (data.startPosition == position) return StructureNodeType.START_NODE;
    if (data.targetPosition == position) return StructureNodeType.TARGET_NODE;
    return StructureNodeType.NORMAL_NODE;
  }
}

enum StructureNodeType
{
  START_NODE, TARGET_NODE, NORMAL_NODE
}