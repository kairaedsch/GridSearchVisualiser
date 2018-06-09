import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../store/Node.dart';
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
    Array2D<Node> nodes = props.store.nodes;

    return (
        Dom.div()
          ..className = "grid"
          ..style =
          {
            "width": "${nodeSize * nodes.width}px",
            "height": "${nodeSize * nodes.height}px"
          }
    )(
        new List<ReactElement>.generate(nodes.height, renderRow)
    );
  }

  ReactElement renderRow(int y) {
    Array2D<Node> nodes = props.store.nodes;

    return (Dom.div()
      ..className = "row"
    )(
        new List<ReactElement>.generate(nodes.width, (x) => renderNode(new Position(x, y)))
    );
  }

  ReactElement renderNode(Position pos) {
    Array2D<Node> nodes = props.store.nodes;
    Node node = nodes.get(pos);

    return (
        ReactNode()
          ..node = node
    )();
  }
}