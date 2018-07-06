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
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store
{
  StoreGridSettings _storeGridSettings;
  Optional<SearchState> _searchState;
  Optional<SearchState> get searchState => _searchState;

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

  StoreGrid(this._storeGridSettings, ActionsHistory actionsHistory)
  {
    int width = _storeGridSettings.size.width;
    int height = _storeGridSettings.size.height;

    _storeNodes = new Array2D<StoreNode>(width, height, (Position pos) => new StoreNode(pos));
    StoreNode sourceStoreNode = _storeNodes[new Position(5, 5)];
    sourceStoreNode.actions.structureNodeChanged.call(sourceStoreNode.structureNode.clone(type: StructureNodeType.SOURCE_NODE));

    StoreNode targetStoreNode = _storeNodes[new Position(10, 5)];
    targetStoreNode.actions.structureNodeChanged.call(targetStoreNode.structureNode.clone(type: StructureNodeType.TARGET_NODE));

    _actions = new ActionsGridChanged();

    actionsHistory.activeChanged.listen(_historyActiveChanged);
    _storeGridSettings.actions.gridModeChanged.listen(_changeGridMode);
  }

  Grid toGrid()
  {
    return new Grid(_storeNodes.width, _storeNodes.height, (Position pos) => new Node(pos, (direction) => leaveAble(pos, direction)));
  }

  bool leaveAble(Position position, Direction direction)
  {
    DirectionMode directionMode = _storeGridSettings.directionMode;
    CrossCornerMode crossCornerMode = _storeGridSettings.crossCornerMode;
    GridMode gridMode = _storeGridSettings.gridMode;

    bool isDirectlyBlocked;
    if (gridMode == GridMode.BASIC)
    {
      isDirectlyBlocked = _leaveBlockedDirectly(position, direction) || _enterBlockedDirectly(position, direction);
    }
    else
    {
      isDirectlyBlocked = _leaveBlockedDirectly(position, direction);
    }

    if (isDirectlyBlocked)
    {
      return false;
    }

    if (directionMode == DirectionMode.ONLY_CARDINAL)
    {
      if (direction.isDiagonal)
      {
        return false;
      }
    }
    else if (directionMode == DirectionMode.ONLY_DIAGONAL)
    {
      if (direction.isCardinal)
      {
        return false;
      }
    }

    if (direction.isDiagonal && crossCornerMode == CrossCornerMode.DENY)
    {
      bool isCornerBlocked = _leaveBlockedDirectly(position, direction)
          || _enterBlockedDirectly(position, direction)
          || _leaveBlockedDirectly(position.go(direction.turn(45)), direction.turn(-90))
          || _enterBlockedDirectly(position.go(direction.turn(45)), direction.turn(-90));

      if (isCornerBlocked)
      {
        return false;
      }
    }

    return true;
  }

  bool _leaveBlockedDirectly(Position position, Direction direction)
  {
    Position targetPosition = position.go(direction);
    return !targetPosition.legal(_storeNodes) || !position.legal(_storeNodes) || _storeNodes[targetPosition].structureNode.barrier.isBlocked(direction.turn(180));
  }

  bool _enterBlockedDirectly(Position position, Direction direction)
  {
    Position startPosition = position.go(direction);
    return !startPosition.legal(_storeNodes) || !position.legal(_storeNodes) || _storeNodes[position].structureNode.barrier.isBlocked(direction);
  }

  void _historyActiveChanged(HistoryPart part)
  {
    _searchState = new Optional.of(part.searchState);
    _storeNodes.iterable.forEach((StoreNode n) => n.actions.explanationNodeChanged(_searchState.value[n.position]));
  }

  void _changeGridMode(GridMode newGridMode)
  {
    trigger();
  }
}

class ActionsGridChanged
{

}
