import '../../general/geo/Direction.dart';
import '../../model/store/Store.dart';
import '../../model/store/Enums.dart';
import '../../general/gui/MouseTracker.dart';
import '../../general/geo/Position.dart';
import '../../model/history/Highlight.dart';
import 'ReactGrid.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';
// ignore: uri_has_not_been_generated
part 'ReactNodePart.over_react.g.dart';

@Factory()
UiFactory<ReactNodePartProps> ReactNodePart = _$ReactNodePart;

@Props()
class _$ReactNodePartProps extends UiProps
{
  Store store;
  ReactGridComponent grid;
  Optional<Direction> direction;
  Optional<DirectionTextHighlight> directionTextHighlight;
  Position position;
}

@State()
class _$ReactNodePartState extends UiState
{
  bool mouseIsOver;
}

@Component()
class ReactNodePartComponent extends UiStatefulComponent<ReactNodePartProps, ReactNodePartState>
{
  Optional<Direction> get direction => props.direction;
  Position get position => props.position;
  Optional<DirectionTextHighlight> get directionTextHighlight => props.directionTextHighlight;

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
            " ${Enums.toName(props.direction.value)}"
            " ${Directions.isDiagonal(direction.value) ? "diagonal" : "cardinal"}"
            " ${position.go(direction.value).legal(props.store.size) ? "legal" : "illegal"}"
            " ${props.store.gridBarrierManager.leaveAble(position, direction.value) ? "leaveUnblocked" : "leaveBlocked"}"
            " ${props.store.gridBarrierManager.enterAble(position, direction.value) ? "enterUnblocked" : "enterBlocked"}"
        )
        ..onMouseDown = ((_) => _handleMouseDown())
        ..onMouseEnter = ((_) => _handleMouseEnter())
        ..onMouseLeave = ((_) => _handleMouseLeave())
      )(
          direction.isNotEmpty && directionTextHighlight.isNotEmpty
              ?
          (Dom.div()
            ..className = "directionTextHighlight"
                " highlight_${directionTextHighlight.value.style}"
          )(
            directionTextHighlight.value.text
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