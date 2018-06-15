import '../../general/Config.dart';
import '../../general/Direction.dart';
import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
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
  StructureNode structureNode;
  ExplanationNode explanationNode;
  Direction direction;
  ActionsNodeChanged actions;
}

@Component()
class ReactNodePartComponent extends UiComponent<ReactNodePartProps>
{
  ReactElement render()
  {
    Direction direction = props.direction;
    StructureNode structureNode = props.structureNode;

    return (Dom.div()
      ..className = "part outer"
          " ${direction.name}"
          " ${structureNode.barrier.isBlocked(direction) ? "blocked" : "unblocked"}"
      ..onMouseDown = ((_) => handleMouseDownOnPart())
    )();
  }

  handleMouseDownOnPart()
  {
    Direction direction = props.direction;
    StructureNode structureNode = props.structureNode;

    StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.transform(direction));
    props.actions.structureNodeChanged.call(newStructureNode);
  }
}