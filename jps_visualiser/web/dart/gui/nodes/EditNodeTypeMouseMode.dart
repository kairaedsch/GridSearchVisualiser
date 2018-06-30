import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../store/StoreGridSettings.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';

class EditNodeTypeMouseMode extends MouseMode
{
  StoreNode _CurrentStoreNode;
  StructureNodeType _type;

  EditNodeTypeMouseMode(ReactGridComponent reactGrid, Position position) : super(reactGrid)
  {
    _CurrentStoreNode = reactGrid.props.store.storeNodes.get(position);
    _type = _CurrentStoreNode.structureNode.type;
  }

  void evaluateNode(Position position)
  {
    StoreNode newStoreNode = reactGrid.props.store.storeNodes.get(position);
    if (newStoreNode.structureNode.type == StructureNodeType.NORMAL_NODE && (!newStoreNode.structureNode.barrier.isAnyBlocked() || reactGrid.props.storeGridSettings.gridMode == GridMode.ADVANCED))
    {
      StructureNode _CurrentStoreNodeUpdated = _CurrentStoreNode.structureNode.clone(type: StructureNodeType.NORMAL_NODE);
      _CurrentStoreNode.actions.structureNodeChanged.call(_CurrentStoreNodeUpdated);

      StructureNode newStructureNodeUpdated = newStoreNode.structureNode.clone(type: _type);
      newStoreNode.actions.structureNodeChanged.call(newStructureNodeUpdated);

      _CurrentStoreNode = newStoreNode;
    }
  }

  void evaluateNodePart(Position position, {Direction direction})
  {
    evaluateNode(position);
  }
}