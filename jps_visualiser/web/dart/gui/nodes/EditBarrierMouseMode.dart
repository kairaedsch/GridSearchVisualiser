import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../store/StoreGridSettings.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';
import 'package:quiver/core.dart';

class EditBarrierMouseMode extends MouseMode
{
  Optional<bool> _easyFillModus = const Optional.absent();

  EditBarrierMouseMode(ReactGridComponent reactGrid) : super(reactGrid);

  void evaluateNode(Position position)
  {
    StoreNode storeNode = reactGrid.props.store.storeNodes.get(position);
    StructureNode structureNode = storeNode.structureNode;

    if (reactGrid.props.storeGridSettings.gridMode == GridMode.BASIC && (structureNode.type == StructureNodeType.NORMAL_NODE || structureNode.barrier.isAnyBlocked()))
    {
      bool easyFillModus = getAndUpdateEasyFillModus(!structureNode.barrier.isAnyBlocked());
      StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.transformToTotal(easyFillModus));
      storeNode.actions.structureNodeChanged.call(newStructureNode);
    }
  }

  void evaluateNodePart(Position position, {Direction direction})
  {
    if (reactGrid.props.storeGridSettings.gridMode == GridMode.ADVANCED && direction != null)
    {
      StoreNode storeNode = reactGrid.props.store.storeNodes.get(position);
      StructureNode structureNode = storeNode.structureNode;

      bool easyFillModus = getAndUpdateEasyFillModus(!structureNode.barrier.isBlocked(direction));
      StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.transformTo(direction, easyFillModus));
      storeNode.actions.structureNodeChanged.call(newStructureNode);
    }
  }

  bool getAndUpdateEasyFillModus(bool maybeNewValue)
  {
    _easyFillModus.ifAbsent(() => _easyFillModus = new Optional.of(maybeNewValue));
    return _easyFillModus.value;
  }
}