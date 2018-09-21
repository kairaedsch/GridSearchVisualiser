import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/Grid.dart';
import '../../general/Save.dart';
import '../StoreGridSettings.dart';
import '../grid/StoreNode.dart';
import '../grid/StructureNode.dart';
import '../history/StoreHistory.dart';
import 'GridBarrierManager.dart';
import 'dart:html';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';
import 'dart:convert';

class StoreGrid extends Store
{
  StoreGridSettings _storeGridSettings;
  GridBarrierManager _gridBarrierManager;
  GridBarrierManager get gridBarrierManager => _gridBarrierManager;

  Array2D<StoreNode> _storeNodes;

  StoreNode operator [](Position pos) => _storeNodes[pos];

  final Size size;

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
    : size = _storeGridSettings.size
  {
    _storeNodes = new Array2D<StoreNode>(_storeGridSettings.size, (Position pos) => new StoreNode(pos, actionsHistory));
    StoreNode sourceStoreNode = _storeNodes[new Position(5, 5)];
    sourceStoreNode.actions.structureNodeChanged.call(sourceStoreNode.structureNode.clone(type: StructureNodeType.SOURCE_NODE));

    StoreNode targetStoreNode = _storeNodes[new Position(10, 5)];
    targetStoreNode.actions.structureNodeChanged.call(targetStoreNode.structureNode.clone(type: StructureNodeType.TARGET_NODE));

    _gridBarrierManager = new GridBarrierManager(_storeGridSettings, (Position p) => _storeNodes[p].structureNode.barrier);

    _storeGridSettings.actions.gridModeChanged.listen(_gridSettingsGridModeChanged);

    _actions = new ActionsGridChanged();
  }

  void _gridSettingsGridModeChanged(GridMode newGridMode)
  {
    trigger();
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
    for (StoreNode storeNode in _storeNodes.iterable)
    {
      Position position = storeNode.position;

      var barrier = new Map<Direction, bool>.fromIterable(
          Direction.values,
          key: (Direction d) => d,
          value: (Direction d) => save.readBarrier(position, d));

      StructureNode newStructureNode = storeNode.structureNode.clone(barrier: new StructureNodeBarrier(barrier));
      storeNode.actions.structureNodeChanged.call(newStructureNode);
    }

    _storeNodes[sourcePosition].actions.structureNodeChanged.call(_storeNodes[sourcePosition].structureNode.clone(type: StructureNodeType.NORMAL_NODE));
    _storeNodes[targetPosition].actions.structureNodeChanged.call(_storeNodes[targetPosition].structureNode.clone(type: StructureNodeType.NORMAL_NODE));


    int sourceX = save.readInt(0);
    int sourceY = save.readInt(1);
    int targetX = save.readInt(2);
    int targetY = save.readInt(3);
    StoreNode sourceStoreNode = _storeNodes[new Position(sourceX, sourceY)];
    StoreNode targetStoreNode = _storeNodes[new Position(targetX, targetY)];

    sourceStoreNode.actions.structureNodeChanged.call(sourceStoreNode.structureNode.clone(type: StructureNodeType.SOURCE_NODE));
    targetStoreNode.actions.structureNodeChanged.call(targetStoreNode.structureNode.clone(type: StructureNodeType.TARGET_NODE));
  }
}

class ActionsGridChanged
{

}
