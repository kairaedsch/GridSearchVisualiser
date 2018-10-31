import '../../../general/geo/Position.dart';
import '../../../general/geo/Direction.dart';
import '../../../model/store/Store.dart';
import '../ReactGrid.dart';

abstract class MouseMode
{
  ReactGridComponent _reactGrid;
  ReactGridComponent get reactGrid => _reactGrid;

  Store get store => reactGrid.props.store;

  String get name;

  MouseMode(this._reactGrid);

  void evaluateNode(Position position);
  void evaluateNodePart(Position position, {Direction direction});

  StructureNodeType getStructureNodeType(Position position)
  {
    if (store.startPosition == position) return StructureNodeType.START_NODE;
    if (store.targetPosition == position) return StructureNodeType.TARGET_NODE;
    return StructureNodeType.NORMAL_NODE;
  }
}

enum StructureNodeType
{
  START_NODE, TARGET_NODE, NORMAL_NODE
}