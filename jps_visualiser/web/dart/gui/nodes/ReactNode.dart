import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../../general/Position.dart';
import '../../store/grid/ExplanationNode.dart';
import '../../store/StoreGridSettings.dart';
import '../../store/grid/StoreGrid.dart';
import '../../store/grid/StoreNode.dart';
import '../../store/grid/StructureNode.dart';
import '../../general/gui/ReactPopover.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'arrows/ReactPath.dart';
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

    return
      (Dom.div()
        ..className = "node"
            " ${props.storeGridSettings.gridMode == GridMode.BASIC ? (structureNode.barrier.isAnyBlocked() ? "anyBlocked totalBlocked" : "totalUnblocked") : ""}"
            " ${props.storeGridSettings.gridMode == GridMode.ADVANCED ? (structureNode.barrier.isAnyBlocked() ? "anyBlocked" : "totalUnblocked") : ""}"
            " ${structureNode.type.name}"
            " ${explanationNode.marking.or("")}"
            " ${explanationNode.activeNodeInTurn ? "activeNodeInTurn" : "" }"
            " ${state.mouseIsOver ? "hover" : "noHover"}"
            " ${state.mouseIsDown ? "mouseDown" : "mouseUp"}"
            " ${state.mouseIsOver && props.grid.mouseMode.isPresent ? props.grid.mouseMode.value.name : ""}"
        ..onMouseDown = ((_) => _handleMouseDown())
        ..onMouseUp = ((_) => _handleMouseUp())
        ..onMouseEnter = ((_) => _handleMouseEnter())
        ..onMouseLeave = ((_) => _handleMouseLeave())
      )(
          _renderTextHighlight(),
          _renderPositionHighlight(),
          (state.mouseIsOver && !MouseTracker.tracker.mouseIsDown && explanationNode.info.isPresent) ? (ReactPopover())(explanationNode.info.value) : null,
          _renderInner(),
          _renderArrowsToGo(),
      );
  }

  ReactElement _renderArrowsToGo()
  {
    if (!state.mouseIsOver)
    {
      return null;
    }

    return
      (Dom.div()
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

    if (structureNode.type == StructureNodeType.NORMAL_NODE && !explanationNode.activeNodeInTurn)
    {
      if (props.storeGridSettings.gridMode == GridMode.BASIC)
      {
        return (Dom.div()..className = "parts")();
      }
      if (props.storeGridSettings.gridMode == GridMode.ADVANCED)
      {
        if (structureNode.barrier.isNoneBlocked() && !state.mouseIsOver)
        {
          return (Dom.div()..className = "parts")();
        }
      }
    }

    return
      (Dom.div()
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
    return
      (ReactNodePart()
        ..key = direction
        ..storeGridSettings = props.storeGridSettings
        ..storeNode = props.store
        ..direction = new Optional.fromNullable(direction)
        ..actions = props.actions
        ..grid = props.grid
        ..storeGrid = props.storeGrid
      )();
  }

  ReactElement _renderTextHighlight()
  {
    if (props.store.textHighlight.isEmpty)
    {
      return null;
    }

    return (Dom.div()
      ..className = "textHighlight"
        " highlight_${props.store.textHighlight.value.style}"
    )(
        props.store.textHighlight.value.text
    );
  }

  ReactElement _renderPositionHighlight()
  {
    if (props.store.positionHighlight.isEmpty)
    {
      return null;
    }

    return (Dom.div()
      ..className = "positionHighlight"
        " highlight_${props.store.positionHighlight.value.style}"
    )();
  }
}