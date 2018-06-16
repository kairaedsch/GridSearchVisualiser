import '../../general/Settings.dart';
import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreConfig.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'ReactGrid.dart';
import 'package:over_react/over_react.dart';
import 'dart:html';

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
      ..className = "part outer"
          " ${direction.name}"
          " ${structureNode.barrier.isBlocked(direction) ? "blocked" : "unblocked"}"
      ..onMouseEnter = ((_) => handleMouseEnter())
      ..onMouseLeave = ((_) => handleMouseLeave())
      ..onMouseDown = ((_) => handleMouseDownOnPart())
    )();
  }

  void handleMouseEnter()
  {
    if (MouseTracker.tracker.mouseIsDown)
    {
      handleMouseDownOnPart();
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

  handleMouseDownOnPart()
  {
    Direction direction = props.direction;
    StructureNode structureNode = props.structureNode;

    StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.transform(direction));
    props.actions.structureNodeChanged.call(newStructureNode);
  }
}