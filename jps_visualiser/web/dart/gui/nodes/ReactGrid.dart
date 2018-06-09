import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../store/ExplanationNode.dart';
import '../store/StructureNode.dart';
import '../store/StoreGrid.dart';
import 'ReactNode.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactGridProps> ReactGrid;

@Props()
class ReactGridProps extends FluxUiProps<ActionsGridChanged, StoreGrid>
{
}

@Component()
class ReactGridComponent extends FluxUiComponent<ReactGridProps>
{
  @override
  ReactElement render() {
    Array2D<StructureNode> structureNodes = props.store.structureNodes;

    return (
        Dom.div()
          ..className = "grid"
          ..style =
          {
            "width": "${nodeSize * structureNodes.width}px",
            "height": "${nodeSize * structureNodes.height}px"
          }
    )(
        new List<ReactElement>.generate(structureNodes.height, renderRow)
    );
  }

  ReactElement renderRow(int y) {
    Array2D<StructureNode> structureNodes = props.store.structureNodes;

    return (Dom.div()
      ..className = "row"
    )(
        new List<ReactElement>.generate(structureNodes.width, (x) => renderNode(new Position(x, y)))
    );
  }

  ReactElement renderNode(Position pos) {
    StructureNode structureNode = props.store.structureNodes.get(pos);
    ExplanationNode explanationNode = props.store.explanationNodes.get(pos);

    return (
        ReactNode()
          ..structureNode = structureNode
          ..explanationNode = explanationNode
    )();
  }
}