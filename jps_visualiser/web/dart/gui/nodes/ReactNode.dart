import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreGridSettings.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends FluxUiProps<ActionsNodeChanged, StoreNode>
{
  StoreGridSettings storeGridSettings;
  ReactGridComponent grid;
}

@State()
class ReactNodeState extends UiState
{
  bool mouseIsOver;
  bool mouseIsDown;
}

@Component()
class ReactNodeComponent extends FluxUiStatefulComponent<ReactNodeProps, ReactNodeState>
{
  @override
  Map getInitialState() =>
      (newState()
        ..mouseIsOver = false
        ..mouseIsDown = false
      );

  @override
  ReactElement render()
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (Dom.div()
      ..className = "node"
          " ${"pos_x_${structureNode.pos.x} pos_y_${structureNode.pos.y}"}"
          " ${props.storeGridSettings.gridMode == GridMode.BASIC ? (structureNode.barrier.isAnyBlocked() ? "totalBlocked" : "totalUnblocked") : ""}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking.name}"
          " ${state.mouseIsOver ? "hover" : ""}"
          " ${state.mouseIsDown ? "mouseDown" : "mouseUp"}"
      ..onMouseDown = ((_) => _handleMouseDown())
      ..onMouseUp = ((_) => _handleMouseUp())
      ..onMouseEnter = ((_) => _handleMouseEnter())
      ..onMouseLeave = ((_) => _handleMouseLeave())
    )(
        _renderInner()
    );
  }

  void _handleMouseDown()
  {
    setState(newState()
      ..mouseIsDown = true
    );
    _triggerMouseMode();
  }

  void _handleMouseUp() {
    setState(newState()
      ..mouseIsDown = false
    );
  }

  void _handleMouseEnter()
  {
    if (MouseTracker.tracker.mouseIsDown)
    {
      _triggerMouseMode();
    }
    setState(newState()
      ..mouseIsOver = true
      ..mouseIsDown = MouseTracker.tracker.mouseIsDown
    );
  }

  void _handleMouseLeave() {
    setState(newState()
      ..mouseIsOver = false
      ..mouseIsDown = false
    );
  }

  void _triggerMouseMode() {
    props.grid.updateMouseModeFromNode(props.store.structureNode);
  }

  List<ReactElement> _renderInner()
  {
    return
    [
      _renderPart(direction: Direction.NORTH_WEST),
      _renderPart(direction: Direction.NORTH),
      _renderPart(direction: Direction.NORTH_EAST),
      _renderPart(direction: Direction.WEST),
      _renderPart(),
      _renderPart(direction: Direction.EAST),
      _renderPart(direction: Direction.SOUTH_WEST),
      _renderPart(direction: Direction.SOUTH),
      _renderPart(direction: Direction.SOUTH_EAST)
    ];
  }

  ReactElement _renderPart({Direction direction})
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (ReactNodePart()
      ..key = direction
      ..storeGridSettings = props.storeGridSettings
      ..structureNode = structureNode
      ..explanationNode = explanationNode
      ..direction = new Optional.fromNullable(direction)
      ..actions = props.actions
      ..grid = props.grid
    )();
  }
}