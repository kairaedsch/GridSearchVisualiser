import '../../general/Config.dart';
import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'package:over_react/over_react.dart';
import 'dart:html';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends FluxUiProps<ActionsNodeChanged, StoreNode>
{
  ReactGridComponent grid;
}

@State()
class ReactNodeState extends UiState
{
  bool mouseIsOver;
}

@Component()
class ReactNodeComponent extends FluxUiStatefulComponent<ReactNodeProps, ReactNodeState>
{
  @override
  Map getInitialState() =>
      (newState()
        ..mouseIsOver = false
      );

  @override
  ReactElement render()
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (Dom.div()
      ..className = "node"
          " ${"pos_x_${structureNode.pos.x} pos_y_${structureNode.pos.y}"}"
          " ${Config.gridMode == GridMode.BASIC ? (structureNode.barrier.isAnyBlocked() ? "totalBlocked" : "totalUnblocked") : ""}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking.name}"
          " ${state.mouseIsOver ? "hover" : ""}"
      ..onMouseEnter = ((_) => handleMouseEnter())
      ..onMouseLeave = ((_) => handleMouseLeave())
      ..onMouseDown = ((_) => handleMouseDown())
    )(
        renderInner(Direction.NORTH_WEST),
        renderInner(Direction.NORTH),
        renderInner(Direction.NORTH_EAST),
        renderInner(Direction.WEST),
        (Dom.div()..className = "part inner")(),
        renderInner(Direction.EAST),
        renderInner(Direction.SOUTH_WEST),
        renderInner(Direction.SOUTH),
        renderInner(Direction.SOUTH_EAST),
    );
  }

  void handleMouseEnter()
  {
    if (MouseTracker.tracker.mouseIsDown)
    {
      changeBarrier();
    }
    setState(newState()
      ..mouseIsOver = true
    );
  }

  handleMouseLeave() {
    setState(newState()
      ..mouseIsOver = false
    );
  }

  void handleMouseDown()
  {
    StructureNode structureNode = props.store.structureNode;
    props.grid.easyFillModus = !structureNode.barrier.isAnyBlocked();
    changeBarrier();
  }

  void changeBarrier()
  {
    if (Config.gridMode == GridMode.BASIC)
    {
      StructureNode structureNode = props.store.structureNode;
      StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.transformToTotal(props.grid.easyFillModus));
      props.actions.structureNodeChanged.call(newStructureNode);
    }
  }

  ReactElement renderInner(Direction direction)
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (ReactNodePart()
      ..key = direction
      ..structureNode = structureNode
      ..explanationNode = explanationNode
      ..direction = direction
      ..actions = props.actions
    )();
  }
}