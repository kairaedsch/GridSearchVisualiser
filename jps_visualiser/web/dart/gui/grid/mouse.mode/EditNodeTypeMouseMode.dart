import '../../../general/geo/Position.dart';
import '../../../model/grid/Direction.dart';
import '../../../model/store/GridSettings.dart';
import '../ReactGrid.dart';
import 'MouseMode.dart';

class EditNodeTypeMouseMode extends MouseMode
{
  StructureNodeType _structureTypeChanging;

  EditNodeTypeMouseMode(ReactGridComponent reactGrid, Position position) : super(reactGrid)
  {
    _structureTypeChanging = getStructureNodeType(position);
  }

  String get name => "EditNodeTypeMouseMode";

  @override
  void evaluateNode(Position position)
  {
    var barrier = store.getBarrier(position);
    var structureNodeType = getStructureNodeType(position);

    if (structureNodeType == StructureNodeType.NORMAL_NODE && (!barrier.isAnyBlocked() || store.gridMode != GridMode.BASIC))
    {
      if (_structureTypeChanging == StructureNodeType.START_NODE)
      {
        store.startPosition = position;
      }
      if (_structureTypeChanging == StructureNodeType.TARGET_NODE)
      {
        store.targetPosition = position;
      }
    }
  }

  @override
  void evaluateNodePart(Position position, {Direction direction})
  {
    evaluateNode(position);
  }
}