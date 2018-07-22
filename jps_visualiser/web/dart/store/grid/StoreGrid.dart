import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/Grid.dart';
import '../StoreGridSettings.dart';
import '../grid/StoreNode.dart';
import '../grid/StructureNode.dart';
import '../history/StoreHistory.dart';
import 'GridBarrierManager.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store implements Size
{
  StoreGridSettings _storeGridSettings;
  GridBarrierManager _gridBarrierManager;
  GridBarrierManager get gridBarrierManager => _gridBarrierManager;

  Array2D<StoreNode> _storeNodes;

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

    _gridBarrierManager = new GridBarrierManager(_storeGridSettings, (Position p) => _storeNodes[p].structureNode.barrier);

    _storeGridSettings.actions.gridModeChanged.listen(_gridSettingsGridModeChanged);

    _actions = new ActionsGridChanged();
  }

  void _gridSettingsGridModeChanged(GridMode newGridMode)
  {
    trigger();
  }
}

class ActionsGridChanged
{

}
