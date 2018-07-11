import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../../general/Position.dart';
import '../store/grid/ExplanationNode.dart';
import '../store/StoreGridSettings.dart';
import '../store/grid/StoreGrid.dart';
import '../store/grid/StoreNode.dart';
import '../store/grid/StructureNode.dart';
import '../../general/gui/ReactPopover.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'ReactPath.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/src/store.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends FluxUiProps<ActionsNodeChanged, StoreNode>
{
  StoreGridSettings storeGridSettings;
  StoreGrid storeGrid;
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
  List<Store> redrawOn() {
    Position position = props.store.position;
    StoreGrid storeGrid = props.storeGrid;
    List<StoreNode> neighbours = Direction.values
        .map((d) => position.go(d))
        .where((Position position) => position.legal(props.storeGridSettings.size))
        .map((Position position) => storeGrid[position]).toList();
    neighbours.add(props.store);
    return neighbours;
  }

  @override
  ReactElement render()
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (Dom.div()
      ..className = "node"
          " ${props.storeGridSettings.gridMode == GridMode.BASIC ? (structureNode.barrier.isAnyBlocked() ? "anyBlocked totalBlocked" : "totalUnblocked") : ""}"
          " ${props.storeGridSettings.gridMode == GridMode.ADVANCED ? (structureNode.barrier.isAnyBlocked() ? "anyBlocked" : "totalUnblocked") : ""}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking.or("")}"
          " ${explanationNode.selectedNodeInTurn ? "selectedNodeInTurn" : "" }"
          " ${explanationNode.markedOpenInTurn ? "markedOpenInTurn" : "" }"
          " ${explanationNode.parentUpdated ? "parentUpdated" : "" }"
          " ${state.mouseIsOver ? "hover" : "noHover"}"
          " ${state.mouseIsDown ? "mouseDown" : "mouseUp"}"
          " ${state.mouseIsOver && props.grid.mouseMode.isPresent ? props.grid.mouseMode.value.name : ""}"
      ..onMouseDown = ((_) => _handleMouseDown())
      ..onMouseUp = ((_) => _handleMouseUp())
      ..onMouseEnter = ((_) => _handleMouseEnter())
      ..onMouseLeave = ((_) => _handleMouseLeave())
    )(
        (state.mouseIsOver && !MouseTracker.tracker.mouseIsDown && explanationNode.info.isPresent) ? (ReactPopover())(explanationNode.info.value) : null,
        _renderInner(),
        _renderParentArrow(props.store.position),
        _renderArrowsToGo()
    );
  }

  ReactElement _renderParentArrow(Position position)
  {
    ExplanationNode explanationNode = props.storeGrid[position].explanationNode;

    if (!explanationNode.parent.isPresent)
    {
      return null;
    }

    return (Dom.div()
      ..className = "arrowParent")(
        (ReactPath()
          ..size = props.storeGridSettings.size
          ..path = [explanationNode.parent.value, position]
          ..showEnd = true
        )()
    );
  }

  ReactElement _renderArrowsToGo()
  {
    if (!state.mouseIsOver)
    {
      return null;
    }

    return (Dom.div()
      ..className = "arrowsToGo")(
        Direction.values.map(_renderArrowToGo).toList()
    );
  }

  ReactElement _renderArrowToGo(Direction direction)
  {
    Position neighbourPosition = props.store.position.go(direction);
    if (!neighbourPosition.legal(props.storeGridSettings.size))
    {
      return null;
    }

    bool leaveAble = props.storeGrid.leaveAble(props.store.position, direction);
    bool enterAble = props.storeGrid.leaveAble(neighbourPosition, direction.turn(180));

    if (!enterAble && !leaveAble)
    {
      return null;
    }

    return
      (ReactPath()
        ..key = direction
        ..size = props.storeGridSettings.size
        ..path = [props.store.position, neighbourPosition]
        ..showEnd = leaveAble && !(enterAble && leaveAble)
        ..showStart = enterAble && !(enterAble && leaveAble)
      )();
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

  ReactElement _renderInner()
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    if (structureNode.type == StructureNodeType.NORMAL_NODE && !explanationNode.selectedNodeInTurn)
    {
      if (props.storeGridSettings.gridMode == GridMode.BASIC)
      {
        return null;
      }
      if (props.storeGridSettings.gridMode == GridMode.ADVANCED)
      {
        if (structureNode.barrier.isNoneBlocked() && !state.mouseIsOver)
        {
          return null;
        }
      }
    }

    return (Dom.div()
      ..className = "parts")(
        _renderPart(direction: Direction.NORTH_WEST),
        _renderPart(direction: Direction.NORTH),
        _renderPart(direction: Direction.NORTH_EAST),
        _renderPart(direction: Direction.WEST),
        _renderPart(),
        _renderPart(direction: Direction.EAST),
        _renderPart(direction: Direction.SOUTH_WEST),
        _renderPart(direction: Direction.SOUTH),
        _renderPart(direction: Direction.SOUTH_EAST)
    );
  }

  ReactElement _renderPart({Direction direction})
  {
    return (ReactNodePart()
      ..key = direction
      ..storeGridSettings = props.storeGridSettings
      ..storeNode = props.store
      ..direction = new Optional.fromNullable(direction)
      ..actions = props.actions
      ..grid = props.grid
      ..storeGrid = props.storeGrid
    )();
  }
}