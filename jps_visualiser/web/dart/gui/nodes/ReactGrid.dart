import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../store/StoreConfig.dart';
import '../store/StoreNode.dart';
import '../store/StoreGrid.dart';
import '../store/StructureNode.dart';
import 'EditBarrierMouseMode.dart';
import 'EditNodeTypeMouseMode.dart';
import 'MouseMode.dart';
import 'ReactNode.dart';
import 'dart:async';
import 'dart:html';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

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
  Optional<MouseMode> _mouseMode;
  StreamSubscription onDocumentMouseUpListener;

  ReactGridComponent()
  {
    _mouseMode = const Optional.absent();
    onDocumentMouseUpListener = window.document.onMouseUp.listen((event) => _mouseMode = const Optional.absent());
  }

  @override
  ReactElement render()
  {
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

  ReactElement renderRow(int y)
  {
    Array2D<StoreNode> storeNodes = props.store.storeNodes;

    return (Dom.div()
      ..className = "row"
      ..key = y
    )(
        new List<ReactElement>.generate(storeNodes.width, (x) => renderNode(new Position(x, y)))
    );
  }

  ReactElement renderNode(Position pos)
  {
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

  MouseMode updateMouseMode(StructureNode structureNode)
  {
    _mouseMode.ifAbsent(()
    {
      if (structureNode.type != StructureNodeType.NORMAL_NODE)
      {
        _mouseMode = new Optional.of(new EditNodeTypeMouseMode(this, structureNode.pos));
      }
      else
      {
        _mouseMode = new Optional.of(new EditBarrierMouseMode(this));
      }
    });

    return _mouseMode.value;
  }

  void componentWillUnmount()
  {
    componentWillUnmount();
    onDocumentMouseUpListener.cancel();
  }
}