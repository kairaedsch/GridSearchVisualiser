import '../../../general/Array2D.dart';
import '../../../general/Direction.dart';
import '../../../general/Position.dart';
import '../../../general/Size.dart';
import '../../../model/Grid.dart';
import '../../../model/SearchState.dart';
import '../StoreGridSettings.dart';
import '../grid/StoreNode.dart';
import '../grid/StructureNode.dart';
import '../history/HistoryPart.dart';
import '../history/StoreHistory.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store implements Size
{
  StoreGridSettings _storeGridSettings;

  Optional<HistoryPart> _historyPart;
  Optional<HistoryPart> get historyPart => _historyPart;

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
    _historyPart = const Optional.absent();
    _storeNodes = new Array2D<StoreNode>(_storeGridSettings.size, (Position pos) => new StoreNode(pos));
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

  void _historyActiveChanged(HistoryPart part)
  {
    _historyPart = new Optional.of(part);
    _storeNodes.iterable.forEach((StoreNode n) => n.actions.explanationNodeChanged(part.explanationNodes[n.position]));
  }

  void _changeGridMode(GridMode newGridMode)
  {
    trigger();
  }
}

class ActionsGridChanged
{

}
