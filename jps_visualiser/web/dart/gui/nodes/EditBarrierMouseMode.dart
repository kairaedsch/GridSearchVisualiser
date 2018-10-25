import '../../futuuure/grid/Direction.dart';
import '../../futuuure/transfer/GridSettings.dart';
import '../../general/Position.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';
import 'package:quiver/core.dart';

class EditBarrierMouseMode extends MouseMode
{
  Optional<bool> _easyFillMode = const Optional.absent();

  EditBarrierMouseMode(ReactGridComponent reactGrid) : super(reactGrid);

  String get name => "EditBarrierMouseMode";

  void evaluateNode(Position position)
  {
    var barrier = data.getBarrier(position);
    var structureNodeType = getStructureNodeType(position);

    if (data.gridMode == GridMode.BASIC && (structureNodeType == StructureNodeType.NORMAL_NODE || barrier.isAnyBlocked()))
    {
      bool maybeNewEasyFillMode = !barrier.isAnyBlocked();
      bool easyFillMode = _getAndUpdateEasyFillMode(maybeNewEasyFillMode);
      if (maybeNewEasyFillMode == easyFillMode)
      {
        data.gridBarrierManager.setTotal(position, easyFillMode);
      }
    }
  }

  void evaluateNodePart(Position position, {Direction direction})
  {
    if (direction != null)
    {
      if (data.gridMode == GridMode.ADVANCED)
      {
        bool maybeNewEasyFillModus =  data.gridBarrierManager.enterAble(position, direction);
        bool easyFillModus = _getAndUpdateEasyFillMode(maybeNewEasyFillModus);
        if (maybeNewEasyFillModus == easyFillModus)
        {
          data.gridBarrierManager.set(position, direction, easyFillModus);
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