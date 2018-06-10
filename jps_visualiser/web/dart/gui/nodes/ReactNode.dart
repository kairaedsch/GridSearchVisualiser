import '../store/ExplanationNode.dart';
import '../store/StoreGrid.dart';
import '../store/StructureNode.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends UiProps
{
  StructureNode structureNode;
  ExplanationNode explanationNode;
  ActionsGridChanged actions;
}

@Component()
class ReactNodeComponent extends UiComponent<ReactNodeProps>
{
  @override
  render()
  {
    StructureNode structureNode = props.structureNode;
    ExplanationNode explanationNode = props.explanationNode;

    return (Dom.div()
      ..className = "node"
          " ${structureNode.pos.css}"
          " ${structureNode.barrier.css}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking.name}"
      ..onClick = handleClick
    )();
  }

  void handleClick(SyntheticMouseEvent event) {
    StructureNode structureNode = props.structureNode;
    StructureNode newStructureNode = structureNode.clone(barrier: structureNode.barrier.invert());
    props.actions.structureNodeChanged.call(newStructureNode);
  }
}