import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../store/StoreNode.dart';
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
  bool _easyFillModus = false;

  bool get easyFillModus => _easyFillModus;

  void set easyFillModus(bool value) => _easyFillModus = value;

  @override
  ReactElement render() {
    Array2D<StoreNode> storeNodes = props.store.storeNodes;

    return (
        Dom.div()
          ..className = "grid"
          ..style =
          {
            "width": "${nodeSize * storeNodes.width}px",
            "height": "${nodeSize * storeNodes.height}px"
          }
    )(
        new List<ReactElement>.generate(storeNodes.height, renderRow)
    );
  }

  ReactElement renderRow(int y) {
    Array2D<StoreNode> storeNodes = props.store.storeNodes;

    return (Dom.div()
      ..className = "row"
      ..key = y
    )(
        new List<ReactElement>.generate(storeNodes.width, (x) => renderNode(new Position(x, y)))
    );
  }

  ReactElement renderNode(Position pos) {
    StoreNode storeNode = props.store.storeNodes.get(pos);

    return (
        ReactNode()
          ..key = pos
          ..store = storeNode
          ..actions = storeNode.actions
          ..grid = this
    )();
  }
}