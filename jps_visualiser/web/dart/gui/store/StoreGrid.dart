import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../model/Grid.dart';
import 'StoreGridSettings.dart';
import 'StoreNode.dart';
import 'StructureNode.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store
{
  Array2D<StoreNode> _storeNodes;

  Array2D<StoreNode> get storeNodes => _storeNodes;

  ActionsGridChanged _actions;

  ActionsGridChanged get actions => _actions;

  Position get sourcePosition =>
      _storeNodes.iterable
          .where((n) => n.structureNode.type == StructureNodeType.SOURCE_NODE)
          .first
          .structureNode
          .position;

  Position get targetPosition =>
      _storeNodes.iterable
          .where((n) => n.structureNode.type == StructureNodeType.TARGET_NODE)
          .first
          .structureNode
          .position;

  StoreGrid(StoreGridSettings storeGridSettings)
  {
    int width = storeGridSettings.size.item1;
    int height = storeGridSettings.size.item2;

    _actions = new ActionsGridChanged();
    _storeNodes = new Array2D<StoreNode>(width, height, (Position pos) => new StoreNode(storeGridSettings, pos));
    StoreNode sourceStoreNode = _storeNodes[new Position(5, 5)];
    sourceStoreNode.actions.structureNodeChanged.call(sourceStoreNode.structureNode.clone(type: StructureNodeType.SOURCE_NODE));

    StoreNode targetStoreNode = _storeNodes[new Position(10, 5)];
    targetStoreNode.actions.structureNodeChanged.call(targetStoreNode.structureNode.clone(type: StructureNodeType.TARGET_NODE));
  }

  Grid toGrid(bool allowDiagonal, bool crossCorner)
  {
    return new Grid(_storeNodes.width, _storeNodes.height, (Position pos) => new Node(pos, (direction) => _leaveAble(allowDiagonal, crossCorner, pos, direction)));
  }

  bool _leaveAble(bool allowDiagonal, bool crossCorner, Position position, Direction direction)
  {
    Position targetPosition = position.go(direction);
    bool isBlocked;
    if (targetPosition.legal(_storeNodes.width, _storeNodes.height))
    {
      isBlocked = _storeNodes[targetPosition].structureNode.barrier.isBlocked(direction.turn(180));
    }
    else
    {
      isBlocked = true;
    }
    return !isBlocked
        &&
        (allowDiagonal || direction.isCardinal)
        &&
        (crossCorner || false);
  }
}

class ActionsGridChanged
{

}
