import '../../general/geo/Direction.dart';
import '../../general/transfer/StoreTransferAble.dart';
import '../../model/store/grid/Barrier.dart';
import '../../model/store/Store.dart';
import '../../model/store/Enums.dart';
import '../../general/gui/MouseTracker.dart';
import '../../general/geo/Position.dart';
import '../../model/history/Highlight.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'arrows/ReactArrow.dart';
import 'arrows/ReactPaths.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';
// ignore: uri_has_not_been_generated
part 'ReactNode.over_react.g.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode = _$ReactNode;

@Props()
class _$ReactNodeProps extends UiProps
{
  Store store;
  ReactGridComponent grid;
  Position position;
}

@State()
class _$ReactNodeState extends UiState
{
  bool mouseIsOver;
  bool mouseIsDown;
}

@Component()
class ReactNodeComponent extends UiStatefulComponent<ReactNodeProps, ReactNodeState>
{
  EqualListener listener;

  Barrier get barrier => props.store.getBarrier(props.position);

  List<Highlight> get backgroundHighlights => props.store.getCurrentStepHighlights(props.position, "background");
  List<Highlight> get foregroundHighlights => props.store.getCurrentStepHighlights(props.position, props.store.currentStepDescriptionHoverId);

  Iterable<Highlight> get highlights => backgroundHighlights..addAll(foregroundHighlights);

  Optional<BoxHighlight> get boxHighlight => new Optional.fromNullable(highlights.lastWhere((h) => h is BoxHighlight, orElse: () => null) as BoxHighlight);
  Iterable<DirectionTextHighlight> get directionTextHighlights => highlights.where((h) => h is DirectionTextHighlight).map((h) => h as DirectionTextHighlight);
  Iterable<PathHighlight> get pathHighlights => highlights.where((h) => h is PathHighlight).map((h) => h as PathHighlight);
  Optional<TextHighlight> get textHighlight => new Optional.fromNullable(highlights.lastWhere((h) => h is TextHighlight, orElse: () => null) as TextHighlight);
  Optional<CircleHighlight> get circleHighlight => new Optional.fromNullable(highlights.lastWhere((h) => h is CircleHighlight, orElse: () => null) as CircleHighlight);
  Optional<DotHighlight> get dotHighlight => new Optional.fromNullable(highlights.lastWhere((h) => h is DotHighlight, orElse: () => null) as DotHighlight);

  @override
  Map getInitialState() =>
      (newState()
        ..mouseIsOver = false
        ..mouseIsDown = false
      );

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = () => redraw();
    var neighbourBarriers = props.position.neighbours(props.store.size).map((p) => "barrier_${p}");
    props.store.addEqualListener(["barrier_${props.position}", "currentStepHighlights_${props.position}", "position_${props.position}"]..addAll(neighbourBarriers), listener);
  }

  @override
  ReactElement render()
  {
    // Util.print("render Node ${props.position}");
    return
      (Dom.div()
        ..className = "node"
            " ${props.store.gridMode == GridMode.BASIC ? (barrier.isAnyBlocked() ? "anyBlocked totalBlocked" : "totalUnblocked") : ""}"
            " ${props.store.gridMode == GridMode.ADVANCED ? (barrier.isAnyBlocked() ? "anyBlocked" : "totalUnblocked") : ""}"
            " ${props.store.startPosition == props.position ? "SOURCE_NODE" : (props.store.targetPosition == props.position ? "TARGET_NODE" : "NORMAL_NODE")}"
            " ${state.mouseIsOver ? "hover" : "noHover"}"
            " ${state.mouseIsDown ? "mouseDown" : "mouseUp"}"
            " ${state.mouseIsOver && props.grid.mouseMode.isPresent ? props.grid.mouseMode.value.name : ""}"
            " ${boxHighlight.isPresent ? "boxHighlight highlight_${boxHighlight.value.style}" : ""}"
        ..onMouseDown = ((_) => _handleMouseDown())
        ..onMouseUp = ((_) => _handleMouseUp())
        ..onMouseEnter = ((_) => _handleMouseEnter())
        ..onMouseLeave = ((_) => _handleMouseLeave())
      )(
          _renderTextHighlight(),
          _renderCircleHighlight(),
          _renderDotHighlight(),
          _renderInner(),
          _renderArrowsToGo(),
          _renderPathHighlights()
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
    props.grid.updateMouseModeFromNode(props.position);
  }

  ReactElement _renderInner()
  {
    if (directionTextHighlights.isEmpty && (props.store.startPosition != props.position && props.store.targetPosition != props.position))
    {
      if (props.store.gridMode == GridMode.BASIC)
      {
        return null;
      }
      else
      {
        if (props.store.gridBarrierManager.somethingToDisplay(props.position) && !state.mouseIsOver)
        {
          return null;
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
        ..grid = props.grid
        ..store = props.store
        ..key = direction
        ..direction = new Optional.fromNullable(direction)
        ..directionTextHighlight = new Optional.fromNullable(directionTextHighlights.lastWhere((h) => h.direction == direction, orElse: () => null) as DirectionTextHighlight)
        ..position = props.position
      )();
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
    bool leaveAble = props.store.gridBarrierManager.leaveAble(props.position, direction);
    bool enterAble = props.store.gridBarrierManager.enterAble(props.position, direction);

    if (!enterAble && !leaveAble)
    {
      return null;
    }

    return
      (ReactArrow()
        ..key = direction
        ..size = props.store.size
        ..path = [props.position, props.position.go(direction)]
        ..showEnd = leaveAble && !(enterAble && leaveAble)
        ..showStart = enterAble && !(enterAble && leaveAble)
      )();
  }

  ReactElement _renderPathHighlights()
  {
    if (!state.mouseIsOver)
    {
      return null;
    }

    return
      (Dom.div()
        ..className = "pathHighlights")(
          pathHighlights.map((highlight) => ReactPathsComponent.renderPathHighlight(highlight, props.store.size, true)).toList()
      );
  }

  ReactElement _renderTextHighlight()
  {
    if (textHighlight.isEmpty)
    {
      return null;
    }

    return (Dom.div()
      ..className = "textHighlight"
        " highlight_${textHighlight.value.style}"
    )(
        textHighlight.value.text
    );
  }

  ReactElement _renderCircleHighlight()
  {
    if (circleHighlight.isEmpty)
    {
      return null;
    }

    return (Dom.div()
      ..className = "circleHighlight"
          " highlight_${circleHighlight.value.style}"
    )();
  }

  ReactElement _renderDotHighlight()
  {
    if (dotHighlight.isEmpty)
    {
      return null;
    }

    return (Dom.div()
      ..className = "dotHighlight"
        " highlight_${dotHighlight.value.style}"
    )();
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.store.removeEqualListener(listener);
  }
}