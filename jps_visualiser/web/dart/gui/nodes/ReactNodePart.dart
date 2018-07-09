import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../../general/Position.dart';
import '../store/StoreGridSettings.dart';
import '../store/grid/StoreNode.dart';
import '../store/grid/StructureNode.dart';
import '../store/grid/StoreGrid.dart';
import 'ReactGrid.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

@Factory()
UiFactory<ReactNodePartProps> ReactNodePart;

@Props()
class ReactNodePartProps extends UiProps
{
  StoreGridSettings storeGridSettings;
  StoreNode storeNode;
  Optional<Direction> direction;
  ActionsNodeChanged actions;
  ReactGridComponent grid;
  StoreGrid storeGrid;
}

@State()
class ReactNodePartState extends UiState
{
  bool mouseIsOver;
}

@Component()
class ReactNodePartComponent extends UiStatefulComponent<ReactNodePartProps, ReactNodePartState>
{
  @override
  Map getInitialState() =>
      (newState()
        ..mouseIsOver = false
      );

  ReactElement render()
  {
    Optional<Direction> direction = props.direction;
    StructureNode structureNode = props.storeNode.structureNode;
    Position position = props.storeNode.position;

    return (Dom.div()
      ..className =
          direction.isEmpty ?
          (
              "part inner"
          )
              :
          (
            "part outer"
            " ${direction.value.name}"
            " ${direction.value.isDiagonal ? "diagonal" : "cardinal"}"
            " ${props.storeGrid.leaveBlockedDirectly(position, direction.value) ? "leaveBlocked" : "leaveUnblocked"}"
            " ${structureNode.barrier.isBlocked(direction.value) ? "blocked" : "unblocked"}"
          )
      ..onMouseDown = ((_) => _handleMouseDown())
      ..onMouseEnter = ((_) => _handleMouseEnter())
      ..onMouseLeave = ((_) => _handleMouseLeave())
    )();
  }

  void _handleMouseDown() {
    _triggerMouseMode();
  }

  void _handleMouseEnter()
  {
    if (MouseTracker.tracker.mouseIsDown)
    {
      _triggerMouseMode();
    }
    setState(newState()
      ..mouseIsOver = true
    );
  }

  void _handleMouseLeave() {
    setState(newState()
      ..mouseIsOver = false
    );
  }

  void _triggerMouseMode() {
    props.grid.updateMouseModeFromNodePart(props.storeNode, direction: props.direction.orNull);
  }
}