import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreGridSettings.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

@Factory()
UiFactory<ReactNodePartProps> ReactNodePart;

@Props()
class ReactNodePartProps extends UiProps
{
  StoreGridSettings storeGridSettings;
  StructureNode structureNode;
  ExplanationNode explanationNode;
  Optional<Direction> direction;
  ActionsNodeChanged actions;
  ReactGridComponent grid;
}

@State()
class ReactNodePartState extends UiState
{
  bool mouseIsOver;
}

@Component()
class ReactNodePartComponent extends UiStatefulComponent<ReactNodePartProps, ReactNodePartState>
{
  @override
  Map getInitialState() =>
      (newState()
        ..mouseIsOver = false
      );

  ReactElement render()
  {
    Optional<Direction> direction = props.direction;
    StructureNode structureNode = props.structureNode;

    return (Dom.div()
      ..className =
          direction.isEmpty ?
          (
              "innerpart"
          )
              :
          (
            "part"
            " ${direction.value.name}"
            " ${structureNode.barrier.isBlocked(direction.value) ? "blocked" : "unblocked"}"
          )
      ..onMouseDown = ((_) => _handleMouseDown())
      ..onMouseEnter = ((_) => _handleMouseEnter())
      ..onMouseLeave = ((_) => _handleMouseLeave())
    )();
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
    props.grid.updateMouseModeFromNodePart(props.structureNode, direction: props.direction.orNull);
  }
}