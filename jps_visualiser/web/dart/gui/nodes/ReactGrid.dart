import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../store/StoreConfig.dart';
import '../store/StoreNode.dart';
import '../store/StoreGrid.dart';
import 'ReactNode.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactGridProps> ReactGrid;

@Props()
class ReactGridProps extends FluxUiProps<ActionsGridChanged, StoreGrid>
{
  StoreConfig storeConfig;
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
            " ${props.storeConfig.gridMode.name}"
          ..style =
          {
            "width": "${Settings.nodeSize * storeNodes.width}px",
            "height": "${Settings.nodeSize * storeNodes.height}px"
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
          ..storeConfig = props.storeConfig
          ..store = storeNode
          ..actions = storeNode.actions
          ..grid = this
    )();
  }
}