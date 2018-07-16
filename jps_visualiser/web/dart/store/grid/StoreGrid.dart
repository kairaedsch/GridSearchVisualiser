import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/Grid.dart';
import '../StoreGridSettings.dart';
import '../grid/StoreNode.dart';
import '../grid/StructureNode.dart';
import '../history/StoreHistory.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store implements Size
{
  StoreGridSettings _storeGridSettings;

  Array2D<StoreNode> _storeNodes;
  Array2D<StoreNode> get storeNodes => _storeNodes;
  StoreNode operator [](Position pos) => _storeNodes[pos];

  @override
  int get width => _storeNodes.width;

  @override
  int get height => _storeNodes.height;

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
    _storeNodes = new Array2D<StoreNode>(_storeGridSettings.size, (Position pos) => new StoreNode(pos, actionsHistory));
    StoreNode sourceStoreNode = _storeNodes[new Position(5, 5)];
    sourceStoreNode.actions.structureNodeChanged.call(sourceStoreNode.structureNode.clone(type: StructureNodeType.SOURCE_NODE));

    StoreNode targetStoreNode = _storeNodes[new Position(10, 5)];
    targetStoreNode.actions.structureNodeChanged.call(targetStoreNode.structureNode.clone(type: StructureNodeType.TARGET_NODE));

    _storeGridSettings.actions.gridModeChanged.listen(_gridSettingsGridModeChanged);

    _actions = new ActionsGridChanged();
  }

  void _gridSettingsGridModeChanged(GridMode newGridMode)
  {
    trigger();
  }

  Grid toGrid()
  {
    return new Grid(_storeNodes, (Position pos) => new Node(pos, (direction) => leaveAble(pos, direction)));
  }

  bool leaveAble(Position position, Direction direction)
  {
    DirectionMode directionMode = _storeGridSettings.directionMode;
    CrossCornerMode crossCornerMode = _storeGridSettings.crossCornerMode;
    GridMode gridMode = _storeGridSettings.gridMode;

    bool isDirectlyBlocked;
    if (gridMode == GridMode.BASIC)
    {
      isDirectlyBlocked = leaveBlockedDirectly(position, direction) || enterBlockedDirectly(position, direction);
    }
    else
    {
      isDirectlyBlocked = leaveBlockedDirectly(position, direction);
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
      bool isCornerBlocked = leaveBlockedDirectly(position, direction)
          || enterBlockedDirectly(position, direction)
          || leaveBlockedDirectly(position.go(direction.turn(45)), direction.turn(-90))
          || enterBlockedDirectly(position.go(direction.turn(45)), direction.turn(-90));

      if (isCornerBlocked)
      {
        return false;
      }
    }

    return true;
  }

  bool leaveBlockedDirectly(Position position, Direction direction)
  {
    GridMode gridMode = _storeGridSettings.gridMode;
    Position targetPosition = position.go(direction);
    return !targetPosition.legal(_storeNodes) || !position.legal(_storeNodes) || (gridMode == GridMode.BASIC ? _storeNodes[targetPosition].structureNode.barrier.isAnyBlocked() : _storeNodes[targetPosition].structureNode.barrier.isBlocked(direction.turn(180)));
  }

  bool enterBlockedDirectly(Position position, Direction direction)
  {
    GridMode gridMode = _storeGridSettings.gridMode;
    Position startPosition = position.go(direction);
    return !startPosition.legal(_storeNodes) || !position.legal(_storeNodes) || (gridMode == GridMode.BASIC ? _storeNodes[position].structureNode.barrier.isAnyBlocked() : _storeNodes[position].structureNode.barrier.isBlocked(direction));
  }
}

class ActionsGridChanged
{

}
