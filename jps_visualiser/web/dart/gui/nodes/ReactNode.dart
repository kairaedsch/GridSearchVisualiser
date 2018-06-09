import '../store/ExplanationNode.dart';
import '../store/StructureNode.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends UiProps
{
  StructureNode structureNode;
  ExplanationNode explanationNode;
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
          " ${structureNode.pos}"
          " ${structureNode.type.name}"
          " ${explanationNode.marking}"
      ..onClick = handleClick
    )();
  }

  void handleClick(SyntheticMouseEvent event) {

  }
}