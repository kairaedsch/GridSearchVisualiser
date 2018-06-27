import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreConfig.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends FluxUiProps<ActionsNodeChanged, StoreNode>
{
  StoreConfig storeConfig;
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
          " ${props.storeConfig.gridMode == GridMode.BASIC ? (structureNode.barrier.isAnyBlocked() ? "totalBlocked" : "totalUnblocked") : ""}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking.name}"
          " ${state.mouseIsOver ? "hover" : ""}"
          " ${state.mouseIsDown ? "mouseDown" : ""}"
      ..onMouseDown = ((_) => handleMouseDown())
      ..onMouseUp = ((_) => handleMouseUp())
      ..onMouseEnter = ((_) => handleMouseEnter())
      ..onMouseLeave = ((_) => handleMouseLeave())
    )(
        renderInner()
    );
  }

  void handleMouseDown()
  {
    setState(newState()
      ..mouseIsDown = true
    );
    triggerMouseMode();
  }

  void handleMouseUp() {
    setState(newState()
      ..mouseIsDown = false
    );
  }

  void handleMouseEnter()
  {
    if (MouseTracker.tracker.mouseIsDown)
    {
      triggerMouseMode();
    }
    setState(newState()
      ..mouseIsOver = true
      ..mouseIsDown = MouseTracker.tracker.mouseIsDown
    );
  }

  void handleMouseLeave() {
    setState(newState()
      ..mouseIsOver = false
      ..mouseIsDown = false
    );
  }

  void triggerMouseMode() {
    MouseMode mouseMode = props.grid.updateMouseMode(props.store.structureNode);
    mouseMode.evaluateNode(props.store.structureNode.pos);
  }

  List<ReactElement> renderInner()
  {
    return props.storeConfig.gridMode == GridMode.BASIC ? [] :
    [
      renderInnerPart(Direction.NORTH_WEST),
      renderInnerPart(Direction.NORTH),
      renderInnerPart(Direction.NORTH_EAST),
      renderInnerPart(Direction.WEST),
      (Dom.div()..className = "innerpart")(),
      renderInnerPart(Direction.EAST),
      renderInnerPart(Direction.SOUTH_WEST),
      renderInnerPart(Direction.SOUTH),
      renderInnerPart(Direction.SOUTH_EAST)
    ];
  }

  ReactElement renderInnerPart(Direction direction)
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (ReactNodePart()
      ..key = direction
      ..storeConfig = props.storeConfig
      ..structureNode = structureNode
      ..explanationNode = explanationNode
      ..direction = direction
      ..actions = props.actions
      ..grid = props.grid
    )();
  }
}