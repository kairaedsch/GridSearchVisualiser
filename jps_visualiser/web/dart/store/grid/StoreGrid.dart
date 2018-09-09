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
import 'dart:html';
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

  void downloadGrid()
  {
    dynamic data = null; //new List<List<bool>>.from(_storeNodes.iterable, (StoreNode n) => n.position.toString(), value: (StoreNode n) => Direction.values.map((Direction d) => n.structureNode.barrier.isBlocked(d)).toList());
    var dataJson = JSON.encode(data);
    var blob = new Blob(<dynamic>[dataJson], 'application/json', 'native');
    String url = Url.createObjectUrlFromBlob(blob);
    AnchorElement link = new AnchorElement();
    link.href = url;
    link.download = "grid.json";
    link.click();
  }

  void loadGrid(String dataJson)
  {
    Map<String, List<bool>> data = JSON.decode(dataJson) as Map<String, List<bool>>;
    data.forEach((position, data)
    {

    });
  }
}

class ActionsGridChanged
{

}
