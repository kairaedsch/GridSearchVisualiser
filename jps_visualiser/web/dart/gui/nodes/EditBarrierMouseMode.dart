import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../store/StoreGridSettings.dart';
import '../../store/grid/GridBarrierManager.dart';
import '../../store/grid/StoreNode.dart';
import '../../store/grid/StructureNode.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';
import 'package:quiver/core.dart';

class EditBarrierMouseMode extends MouseMode
{
  Optional<bool> _easyFillModus = const Optional.absent();

  EditBarrierMouseMode(ReactGridComponent reactGrid) : super(reactGrid);

  String get name => "EditBarrierMouseMode";

  void evaluateNode(Position position)
  {
    StoreNode storeNode = reactGrid.props.store[position];
    GridBarrierManager gridBarrierManager = reactGrid.props.store.gridBarrierManager;
    StructureNode structureNode = storeNode.structureNode;

    if (reactGrid.props.storeGridSettings.gridMode == GridMode.BASIC && (structureNode.type == StructureNodeType.NORMAL_NODE || structureNode.barrier.isAnyBlocked()))
    {
      bool maybeNewEasyFillModus = gridBarrierManager.enterAbleInAnyDirection(position);
      bool easyFillModus = getAndUpdateEasyFillModus(maybeNewEasyFillModus);
      if (maybeNewEasyFillModus == easyFillModus)
      {
        StructureNode newStructureNode = structureNode.clone(barrier: gridBarrierManager.getTotal(easyFillModus));
        storeNode.actions.structureNodeChanged.call(newStructureNode);
      }
    }
  }

  void evaluateNodePart(Position position, {Direction direction})
  {
    if (direction != null)
    {
      GridBarrierManager gridBarrierManager = reactGrid.props.store.gridBarrierManager;

      if (reactGrid.props.storeGridSettings.gridMode == GridMode.ADVANCED)
      {
        bool maybeNewEasyFillModus = gridBarrierManager.enterAble(position, direction);
        bool easyFillModus = getAndUpdateEasyFillModus(maybeNewEasyFillModus);
        if (maybeNewEasyFillModus == easyFillModus)
        {
          Map<Position, StructureNodeBarrier> changes = gridBarrierManager.transformTo(position, direction, easyFillModus);
          changes.forEach((position, barrier)
          {
            StoreNode storeNode = reactGrid.props.store[position];
            StructureNode structureNode = storeNode.structureNode;
            StructureNode newStructureNode = structureNode.clone(barrier: barrier);
            storeNode.actions.structureNodeChanged.call(newStructureNode);
          });
        }
      }
    }
  }

  bool getAndUpdateEasyFillModus(bool maybeNewValue)
  {
    _easyFillModus.ifAbsent(() => _easyFillModus = new Optional.of(maybeNewValue));
    return _easyFillModus.value;
  }
}