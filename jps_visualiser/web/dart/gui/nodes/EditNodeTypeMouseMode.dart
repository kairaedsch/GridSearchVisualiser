import '../../futuuure/grid/Direction.dart';
import '../../futuuure/transfer/GridSettings.dart';
import '../../general/Position.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';

class EditNodeTypeMouseMode extends MouseMode
{
  StructureNodeType _structureTypeChanging;

  EditNodeTypeMouseMode(ReactGridComponent reactGrid, Position position) : super(reactGrid)
  {
    _structureTypeChanging = getStructureNodeType(position);
  }

  String get name => "EditNodeTypeMouseMode";

  void evaluateNode(Position position)
  {
    var barrier = data.getBarrier(position);
    var structureNodeType = getStructureNodeType(position);

    if (structureNodeType == StructureNodeType.NORMAL_NODE && (!barrier.isAnyBlocked() || data.gridMode != GridMode.BASIC))
    {
      if (_structureTypeChanging == StructureNodeType.START_NODE)
      {
        data.startPosition = position;
      }
      if (_structureTypeChanging == StructureNodeType.TARGET_NODE)
      {
        data.targetPosition = position;
      }
    }
  }

  void evaluateNodePart(Position position, {Direction direction})
  {
    evaluateNode(position);
  }
}