import '../../general/MouseTracker.dart';
import '../store/ExplanationNode.dart';
import '../store/StoreNode.dart';
import '../store/StructureNode.dart';
import 'package:over_react/over_react.dart';
import 'dart:html';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends FluxUiProps<ActionsNodeChanged, StoreNode>
{
}

@Component()
class ReactNodeComponent extends FluxUiComponent<ReactNodeProps>
{
  @override
  render()
  {
    StructureNode structureNode = props.store.structureNode;
    ExplanationNode explanationNode = props.store.explanationNode;

    return (Dom.div()
      ..className = "node"
          " ${structureNode.pos.css}"
          " ${structureNode.barrier.css}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking.name}"
      ..onMouseEnter = ((_) => handleMouseEnter())
      ..onMouseDown = ((_) => changeBarrier())
    )();
  }

  void handleMouseEnter()
  {
    if (MouseTracker.tracker.mouseIsDown)
    {
      changeBarrier();
    }
  }

  void changeBarrier()
  {
    StructureNode structureNode = props.store.structureNode;
    StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.invert());
    props.actions.structureNodeChanged.call(newStructureNode);
  }
}