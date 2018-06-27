import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreConfig.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'MouseMode.dart';
import 'ReactGrid.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactNodePartProps> ReactNodePart;

@Props()
class ReactNodePartProps extends UiProps
{
  StoreConfig storeConfig;
  StructureNode structureNode;
  ExplanationNode explanationNode;
  Direction direction;
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
    Direction direction = props.direction;
    StructureNode structureNode = props.structureNode;

    return (Dom.div()
      ..className = "part"
          " ${direction.name}"
          " ${structureNode.barrier.isBlocked(direction) ? "blocked" : "unblocked"}"
      ..onMouseDown = ((_) => handleMouseDown())
      ..onMouseEnter = ((_) => handleMouseEnter())
      ..onMouseLeave = ((_) => handleMouseLeave())
    )();
  }

  void handleMouseDown() {
    triggerMouseMode();
  }

  void handleMouseEnter()
  {
    if (MouseTracker.tracker.mouseIsDown)
    {
      triggerMouseMode();
    }
    setState(newState()
      ..mouseIsOver = true
    );
  }

  void handleMouseLeave() {
    setState(newState()
      ..mouseIsOver = false
    );
  }

  void triggerMouseMode() {
    MouseMode mouseMode = props.grid.updateMouseMode(props.structureNode);
    mouseMode.evaluateNodePart(props.structureNode.pos, props.direction);
  }
}