import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'ReactGrid.dart';
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
          " ${structureNode.pos.css}"
          " ${structureNode.barrier.css}"
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

  ReactElement renderInner(Direction direction)
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (Dom.div()
      ..key = direction
      ..className = "part outer"
          " ${direction.name}"
          " ${structureNode.barrier.isBlocked(direction) ? "blocked" : "unblocked"}"
    )();
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
    props.grid.easyFillModus = !structureNode.barrier.anyBlocked();
    changeBarrier();
  }

  void changeBarrier()
  {
    StructureNode structureNode = props.store.structureNode;
    StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.toTotal(props.grid.easyFillModus));
    props.actions.structureNodeChanged.call(newStructureNode);
  }
}