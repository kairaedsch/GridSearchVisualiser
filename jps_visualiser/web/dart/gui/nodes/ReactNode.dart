import '../../futuuure/general/DataTransferAble.dart';
import '../../futuuure/grid/Direction.dart';
import '../../futuuure/transfer/Data.dart';
import '../../futuuure/transfer/GridSettings.dart';
import '../../general/MouseTracker.dart';
import '../../general/Position.dart';
import '../../model/history/Highlight.dart';
import '../../futuuure/grid/Barrier.dart';
import 'ReactGrid.dart';
import 'ReactNodePart.dart';
import 'arrows/ReactArrow.dart';
import 'arrows/ReactPaths.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends UiProps
{
  Data data;
  ReactGridComponent grid;
  Position position;
}

@State()
class ReactNodeState extends UiState
{
  bool mouseIsOver;
  bool mouseIsDown;
}

@Component()
class ReactNodeComponent extends UiStatefulComponent<ReactNodeProps, ReactNodeState>
{
  Listener listener;

  Barrier get barrier => props.data.getBarrier(props.position);

  List<Highlight> get backgroundHighlights => props.data.getCurrentStepHighlights(props.position)["background"];
  List<Highlight> get foregroundHighlights => props.data.getCurrentStepHighlights(props.position)["foreground"];

  Iterable<Highlight> get highlights => backgroundHighlights..addAll(foregroundHighlights);

  Optional<BoxHighlight> get boxHighlight => new Optional.fromNullable(highlights.lastWhere((h) => h is BoxHighlight, orElse: () => null) as BoxHighlight);
  Optional<DirectionTextHighlight> get directionTextHighlights => new Optional.fromNullable(highlights.lastWhere((h) => h is DirectionTextHighlight, orElse: () => null) as DirectionTextHighlight);
  Iterable<PathHighlight> get pathHighlights => [];
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

    listener = (String key, dynamic oldValue, dynamic newValue) => redraw();
    props.data.addListener(["barrier_${props.position}", "currentStepHighlights_${props.position}"], listener);
  }

  @override
  ReactElement render()
  {
    print("render Node ${props.position}");
    return
      (Dom.div()
        ..className = "node"
            " ${props.data.gridMode == GridMode.BASIC ? (barrier.isAnyBlocked() ? "anyBlocked totalBlocked" : "totalUnblocked") : ""}"
            " ${props.data.gridMode == GridMode.ADVANCED ? (barrier.isAnyBlocked() ? "anyBlocked" : "totalUnblocked") : ""}"
            " ${props.data.startPosition == props.position ? "SOURCE_NODE" : (props.data.targetPosition == props.position ? "TARGET_NODE" : "NORMAL_NODE")}"
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
    if (directionTextHighlights.isEmpty && (props.data.startPosition != props.position && props.data.targetPosition != props.position))
    {
      if (props.data.gridMode == GridMode.BASIC)
      {
        return null;
      }
      else
      {
        if (props.data.gridBarrierManager.somethingToDisplay(props.position) && !state.mouseIsOver)
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
        ..data = props.data
        ..key = direction
        ..direction = new Optional.fromNullable(direction)
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
    bool leaveAble = props.data.gridBarrierManager.leaveAble(props.position, direction);
    bool enterAble = props.data.gridBarrierManager.enterAble(props.position, direction);

    if (!enterAble && !leaveAble)
    {
      return null;
    }

    return
      (ReactArrow()
        ..key = direction
        ..size = props.data.size
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
          pathHighlights.map((highlight) => ReactPathsComponent.renderPathHighlight(highlight, props.data.size, true)).toList()
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

    props.data.removeListener(listener);
  }
}