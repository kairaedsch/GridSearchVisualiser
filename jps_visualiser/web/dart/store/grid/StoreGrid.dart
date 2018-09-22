import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../general/Save.dart';
import '../StoreGridSettings.dart';
import '../grid/StoreNode.dart';
import '../grid/StructureNode.dart';
import '../history/StoreHistory.dart';
import 'GridBarrierManager.dart';
import 'dart:math';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store
{
  StoreGridSettings _storeGridSettings;
  GridBarrierManager _gridBarrierManager;
  GridBarrierManager get gridBarrierManager => _gridBarrierManager;

  Array2D<StoreNode> _storeNodes;

  StoreNode operator [](Position pos) => _storeNodes[pos];

  Size _size;
  Size get size => _size;

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
    _size = new Size(15, 15);
    _storeNodes = new Array2D<StoreNode>(size, (Position pos) => new StoreNode(pos, actionsHistory));

    _CheckUniqueStructureNodeType(new Position(2, 7), StructureNodeType.SOURCE_NODE);
    _CheckUniqueStructureNodeType(new Position(12, 7), StructureNodeType.TARGET_NODE);

    _storeNodes[new Position(7, 5)].actions.structureNodeChanged.call(_storeNodes[new Position(7, 7)].structureNode.clone(barrier: StructureNodeBarrier.totalBlocked));
    _storeNodes[new Position(7, 6)].actions.structureNodeChanged.call(_storeNodes[new Position(7, 7)].structureNode.clone(barrier: StructureNodeBarrier.totalBlocked));
    _storeNodes[new Position(7, 7)].actions.structureNodeChanged.call(_storeNodes[new Position(7, 7)].structureNode.clone(barrier: StructureNodeBarrier.totalBlocked));
    _storeNodes[new Position(7, 8)].actions.structureNodeChanged.call(_storeNodes[new Position(7, 7)].structureNode.clone(barrier: StructureNodeBarrier.totalBlocked));
    _storeNodes[new Position(7, 9)].actions.structureNodeChanged.call(_storeNodes[new Position(7, 7)].structureNode.clone(barrier: StructureNodeBarrier.totalBlocked));

    _gridBarrierManager = new GridBarrierManager(this, _storeGridSettings, (Position p) => _storeNodes[p].structureNode.barrier);

    _storeGridSettings.actions.gridModeChanged.listen(_gridSettingsGridModeChanged);

    _actions = new ActionsGridChanged();
  }

  void _CheckUniqueStructureNodeType(Position newPosition, StructureNodeType structureNodeType, {bool overwrite})
  {
    overwrite = overwrite == null ? false : true;

    var found = _storeNodes.iterable.where((n) => n.structureNode.type == structureNodeType);
    if (found.isNotEmpty)
    {
      if (!overwrite)
      {
        return;
      }
      found.forEach((s) => s.actions.structureNodeChanged.call(s.structureNode.clone(type: StructureNodeType.NORMAL_NODE)));
    }

    _storeNodes[newPosition].actions.structureNodeChanged.call(_storeNodes[newPosition].structureNode.clone(type: structureNodeType));
  }

  void _gridSettingsGridModeChanged(GridMode newGridMode)
  {
    trigger();
  }

  void smaller()
  {
    _resize(new Size(max(_size.width - 1, 2), max(_size.height - 1, 2)));
    _CheckUniqueStructureNodeType(new Position(0, 0), StructureNodeType.SOURCE_NODE);
    _CheckUniqueStructureNodeType(new Position(1, 1), StructureNodeType.TARGET_NODE);
    trigger();
  }

  void bigger()
  {
    _resize(new Size(min(_size.width + 1, 50), min(_size.height + 1, 50)));
    _CheckUniqueStructureNodeType(new Position(0, 0), StructureNodeType.SOURCE_NODE);
    _CheckUniqueStructureNodeType(new Position(1, 1), StructureNodeType.TARGET_NODE);
    trigger();
  }

  void _resize(Size newSize)
  {
    _size.resize(newSize);
    _storeNodes.resize(newSize);
  }

  void save(Save save)
  {
    for (StoreNode storeNode in _storeNodes.iterable)
    {
      Position position = storeNode.position;
      var barrier = storeNode.structureNode.barrier;
      for (Direction direction in Direction.values)
      {
        save.writeBarrier(position, new Optional.of(direction), barrier.isBlocked(direction));
      }
      save.writeBarrier(position, const Optional.absent(), _storeGridSettings.gridMode == GridMode.BASIC ? barrier.isAnyBlocked() : false);
    }
    save.writeSource(sourcePosition);
    save.writeTarget(targetPosition);
    save.writeInt(0, sourcePosition.x);
    save.writeInt(1, sourcePosition.y);
    save.writeInt(2, targetPosition.x);
    save.writeInt(3, targetPosition.y);
  }

  void load(Save save)
  {
    _resize(save.gridSize);

    int sourceX = save.readInt(0);
    int sourceY = save.readInt(1);
    var newSourcePosition = new Position(sourceX, sourceY);

    int targetX = save.readInt(2);
    int targetY = save.readInt(3);
    var newTargetPosition =new Position(targetX, targetY);

    for (StoreNode storeNode in _storeNodes.iterable)
    {
      Position position = storeNode.position;

      var barrier = new Map<Direction, bool>.fromIterable(
          Direction.values,
          key: (Direction d) => d,
          value: (Direction d) => save.readBarrier(position, d));

      StructureNodeType structureNodeType;
      if (position == newSourcePosition)
      {
        structureNodeType = StructureNodeType.SOURCE_NODE;
      }
      else if (position == newTargetPosition)
      {
        structureNodeType = StructureNodeType.TARGET_NODE;
      }
      else
      {
        structureNodeType = StructureNodeType.NORMAL_NODE;
      }

      StructureNode newStructureNode = storeNode.structureNode.clone(barrier: new StructureNodeBarrier(barrier), type: structureNodeType);
      storeNode.actions.structureNodeChanged.call(newStructureNode);
    }

    trigger();
  }
}

class ActionsGridChanged
{

}
