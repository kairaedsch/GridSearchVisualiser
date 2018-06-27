import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';

class EditNodeTypeMouseMode extends MouseMode
{
  StoreNode _CurrentStoreNode;

  EditNodeTypeMouseMode(ReactGridComponent reactGrid, Position position) : super(reactGrid)
  {
    _CurrentStoreNode = reactGrid.props.store.storeNodes.get(position);
  }

  void evaluateNode(Position position)
  {
    StoreNode newStoreNode = reactGrid.props.store.storeNodes.get(position);
    if (newStoreNode.structureNode.type == StructureNodeType.NORMAL_NODE)
    {
      StructureNode _CurrentStoreNodeUpdated = _CurrentStoreNode.structureNode.clone(type: StructureNodeType.NORMAL_NODE);
      _CurrentStoreNode.actions.structureNodeChanged.call(_CurrentStoreNodeUpdated);

      StructureNode newStructureNodeUpdated = newStoreNode.structureNode.clone(type: _CurrentStoreNode.structureNode.type);
      newStoreNode.actions.structureNodeChanged.call(newStructureNodeUpdated);

      _CurrentStoreNode = newStoreNode;
    }
  }

  void evaluateNodePart(Position position, Direction direction)
  {

  }
}