import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/grid/ExplanationNode.dart';
import '../store/StoreGridSettings.dart';
import '../store/grid/StoreNode.dart';
import '../store/grid/StructureNode.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'ReactArrow.dart';
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
          " ${props.storeGridSettings.gridMode == GridMode.BASIC ? (structureNode.barrier.isAnyBlocked() ? "totalBlocked" : "totalUnblocked") : ""}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking.or("")}"
          " ${explanationNode.selectedNodeInTurn ? "selectedNodeInTurn" : "ghghg" }"
          " ${state.mouseIsOver ? "hover" : ""}"
          " ${state.mouseIsDown ? "mouseDown" : "mouseUp"}"
          " ${state.mouseIsOver && props.grid.mouseMode.isPresent ? props.grid.mouseMode.value.name : ""}"
      ..onMouseDown = ((_) => _handleMouseDown())
      ..onMouseUp = ((_) => _handleMouseUp())
      ..onMouseEnter = ((_) => _handleMouseEnter())
      ..onMouseLeave = ((_) => _handleMouseLeave())
    )(
        (Dom.div()..className = "parts")(
            _renderInner()
        ),
        explanationNode.parent.isPresent ?
          (ReactArrow()
            ..size = props.grid.props.storeGridSettings.size
            ..sourceNode = explanationNode.parent.value
            ..targetNode = props.store.position
          )()
            :
          ""
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
    props.grid.updateMouseModeFromNode(props.store);
  }

  List<ReactElement> _renderInner()
  {
    StructureNode structureNode = props.store.structureNode;

    if (structureNode.type == StructureNodeType.NORMAL_NODE)
    {
      if (props.storeGridSettings.gridMode == GridMode.BASIC)
      {
        return [];
      }
      if (props.storeGridSettings.gridMode == GridMode.ADVANCED)
      {
        if (structureNode.barrier.isNoneBlocked() && !state.mouseIsOver)
        {
          return [];
        }
      }
    }

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
      ..storeNode = props.store
      ..direction = new Optional.fromNullable(direction)
      ..actions = props.actions
      ..grid = props.grid
    )();
  }
}