import '../../../general/geo/Position.dart';
import '../../../general/geo/Direction.dart';
import '../../../model/store/Enums.dart';
import '../ReactGrid.dart';
import 'MouseMode.dart';
import 'package:quiver/core.dart';

class EditBarrierMouseMode extends MouseMode
{
  Optional<bool> _easyFillMode = const Optional.absent();

  EditBarrierMouseMode(ReactGridComponent reactGrid) : super(reactGrid);

  String get name => "EditBarrierMouseMode";

  @override
  void evaluateNode(Position position)
  {
    var barrier = store.getBarrier(position);
    var structureNodeType = getStructureNodeType(position);

    if (store.gridMode == GridMode.BASIC && (structureNodeType == StructureNodeType.NORMAL_NODE || barrier.isAnyBlocked()))
    {
      bool maybeNewEasyFillMode = !barrier.isAnyBlocked();
      bool easyFillMode = _getAndUpdateEasyFillMode(maybeNewEasyFillMode);
      if (maybeNewEasyFillMode == easyFillMode)
      {
        store.gridBarrierManager.setTotal(position, easyFillMode);
      }
    }
  }

  @override
  void evaluateNodePart(Position position, {Direction direction})
  {
    if (direction != null)
    {
      if (store.gridMode == GridMode.ADVANCED)
      {
        bool maybeNewEasyFillModus =  store.gridBarrierManager.enterAble(position, direction);
        bool easyFillModus = _getAndUpdateEasyFillMode(maybeNewEasyFillModus);
        if (maybeNewEasyFillModus == easyFillModus)
        {
          store.gridBarrierManager.set(position, direction, easyFillModus);
        }
      }
    }
  }

  bool _getAndUpdateEasyFillMode(bool maybeNewValue)
  {
    _easyFillMode.ifAbsent(() => _easyFillMode = new Optional.of(maybeNewValue));
    return _easyFillMode.value;
  }
}