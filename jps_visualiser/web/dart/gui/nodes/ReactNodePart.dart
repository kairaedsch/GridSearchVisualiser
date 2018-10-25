import '../../futuuure/grid/Direction.dart';
import '../../futuuure/transfer/Data.dart';
import '../../general/MouseTracker.dart';
import '../../general/Position.dart';
import '../../model/history/Highlight.dart';
import 'ReactGrid.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

@Factory()
UiFactory<ReactNodePartProps> ReactNodePart;

@Props()
class ReactNodePartProps extends UiProps
{
  Data data;
  ReactGridComponent grid;
  Optional<Direction> direction;
  Position position;
}

@State()
class ReactNodePartState extends UiState
{
  bool mouseIsOver;
}

@Component()
class ReactNodePartComponent extends UiStatefulComponent<ReactNodePartProps, ReactNodePartState>
{
  Optional<Direction> get direction => props.direction;
  Position get position => props.position;
  List<DirectionTextHighlight> get directionTextHighlight => [];

  @override
  Map getInitialState() =>
      (newState()
        ..mouseIsOver = false
      );

  ReactElement render()
  {
    return
      (Dom.div()
        ..className =
        direction.isEmpty
            ?
        (
            "part inner"
        )
            :
        (
            "part outer"
            " ${direction.value.toString()}"
            " ${Directions.isDiagonal(direction.value) ? "diagonal" : "cardinal"}"
            " ${position.go(direction.value).legal(props.data.size) ? "legal" : "illegal"}"
            " ${props.data.gridBarrierManager.leaveAble(position, direction.value) ? "leaveUnblocked" : "leaveBlocked"}"
            " ${props.data.gridBarrierManager.enterAble(position, direction.value) ? "enterUnblocked" : "enterBlocked"}"
        )
        ..onMouseDown = ((_) => _handleMouseDown())
        ..onMouseEnter = ((_) => _handleMouseEnter())
        ..onMouseLeave = ((_) => _handleMouseLeave())
      )(
          direction.isNotEmpty && directionTextHighlight.where((d) => d.direction == direction.value).isNotEmpty
              ?
          (Dom.div()
            ..className = "directionTextHighlight"
                " highlight_${directionTextHighlight.where((d) => d.direction == direction.value).first.style}"
          )(
              directionTextHighlight.where((d) => d.direction == direction.value).first.text
          )
              :
          null
      );
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
    props.grid.updateMouseModeFromNodePart(props.position, direction: props.direction.orNull);
  }
}