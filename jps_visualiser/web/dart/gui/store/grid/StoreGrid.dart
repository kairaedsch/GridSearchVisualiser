import '../../../general/Array2D.dart';
import '../../../general/Direction.dart';
import '../../../general/Position.dart';
import '../../../model/Grid.dart';
import '../../../model/SearchState.dart';
import '../StoreGridSettings.dart';
import '../grid/StoreNode.dart';
import '../grid/StructureNode.dart';
import '../history/HistoryPart.dart';
import '../history/StoreHistory.dart';
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
          .position;

  Position get targetPosition =>
      _storeNodes.iterable
          .where((n) => n.structureNode.type == StructureNodeType.TARGET_NODE)
          .first
          .position;

  StoreGrid(StoreGridSettings storeGridSettings, ActionsHistory actionsHistory)
  {
    int width = storeGridSettings.size.width;
    int height = storeGridSettings.size.height;

    _storeNodes = new Array2D<StoreNode>(width, height, (Position pos) => new StoreNode(storeGridSettings, pos));
    StoreNode sourceStoreNode = _storeNodes[new Position(5, 5)];
    sourceStoreNode.actions.structureNodeChanged.call(sourceStoreNode.structureNode.clone(type: StructureNodeType.SOURCE_NODE));

    StoreNode targetStoreNode = _storeNodes[new Position(10, 5)];
    targetStoreNode.actions.structureNodeChanged.call(targetStoreNode.structureNode.clone(type: StructureNodeType.TARGET_NODE));

    _actions = new ActionsGridChanged();

    actionsHistory.activeChanged.listen(historyActiveChanged);
  }

  Grid toGrid(bool allowDiagonal, bool crossCorner)
  {
    return new Grid(_storeNodes.width, _storeNodes.height, (Position pos) => new Node(pos, (direction) => _leaveAble(allowDiagonal, crossCorner, pos, direction)));
  }

  bool _leaveAble(bool allowDiagonal, bool crossCorner, Position position, Direction direction)
  {
    Position targetPosition = position.go(direction);
    bool isBlocked;
    if (targetPosition.legal(_storeNodes))
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
        (crossCorner || true);
  }

  historyActiveChanged(HistoryPart part)
  {
    SearchState searchState = part.searchState;
    _storeNodes.iterable.forEach((StoreNode n) => n.actions.explanationNodeChanged(searchState[n.position]));
  }
}

class ActionsGridChanged
{

}
