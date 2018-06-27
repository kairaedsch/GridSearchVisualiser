import '../../general/Array2D.dart';
import '../../general/Position.dart';
import 'StoreNode.dart';
import 'StructureNode.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store
{
  Array2D<StoreNode> _storeNodes;
  Array2D<StoreNode> get storeNodes => _storeNodes;

  ActionsGridChanged _actions;
  ActionsGridChanged get actions => _actions;

  StoreGrid(int width, int height)
  {
    _actions = new ActionsGridChanged();
    _storeNodes = new Array2D<StoreNode>(width, height, (Position pos) => new StoreNode(pos));
    StoreNode sourceStoreNode = _storeNodes.get(new Position(5, 5));
    sourceStoreNode.actions.structureNodeChanged.call(sourceStoreNode.structureNode.clone(type: StructureNodeType.SOURCE_NODE));

    StoreNode targetStoreNode = _storeNodes.get(new Position(10, 5));
    targetStoreNode.actions.structureNodeChanged.call(targetStoreNode.structureNode.clone(type: StructureNodeType.TARGET_NODE));
  }
}

class ActionsGridChanged
{

}
