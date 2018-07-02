import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../store/StoreGridSettings.dart';
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
  StoreGridSettings storeGridSettings;
}

@Component()
class ReactGridComponent extends FluxUiComponent<ReactGridProps>
{
  Optional<MouseMode> _mouseMode;
  Optional<MouseMode> get mouseMode => _mouseMode;

  StreamSubscription _onDocumentMouseUpListener;

  ReactGridComponent()
  {
    _mouseMode = const Optional.absent();
    _onDocumentMouseUpListener = window.document.onMouseUp.listen((event) => _mouseMode = const Optional.absent());
  }

  @override
  ReactElement render()
  {
    Array2D<StoreNode> storeNodes = props.store.storeNodes;

    return (
        Dom.div()
          ..className = "grid"
              " ${props.storeGridSettings.gridMode.name}"
          ..style =
          {
            "width": "${Settings.nodeSize * storeNodes.width}px",
            "height": "${Settings.nodeSize * storeNodes.height}px"
          }
    )(
        new List<ReactElement>.generate(storeNodes.height, _renderRow)
    );
  }

  ReactElement _renderRow(int y)
  {
    Array2D<StoreNode> storeNodes = props.store.storeNodes;

    return (Dom.div()
      ..className = "row"
      ..key = y
    )(
        new List<ReactElement>.generate(storeNodes.width, (x) => _renderNode(new Position(x, y)))
    );
  }

  ReactElement _renderNode(Position pos)
  {
    StoreNode storeNode = props.store.storeNodes[pos];

    return (
        ReactNode()
          ..key = pos
          ..storeGridSettings = props.storeGridSettings
          ..store = storeNode
          ..actions = storeNode.actions
          ..grid = this
    )();
  }

  void updateMouseModeFromNode(StructureNode structureNode)
  {
    if (props.storeGridSettings.gridMode == GridMode.BASIC && _mouseMode.isEmpty)
    {
      if (structureNode.type != StructureNodeType.NORMAL_NODE)
      {
        _mouseMode = new Optional.of(new EditNodeTypeMouseMode(this, structureNode.position));
      }
      else
      {
        _mouseMode = new Optional.of(new EditBarrierMouseMode(this));
      }
    }
    _mouseMode.ifPresent((mouseMode) => mouseMode.evaluateNode(structureNode.position));
  }

void updateMouseModeFromNodePart(StructureNode structureNode, {Direction direction})
  {
    if (props.storeGridSettings.gridMode == GridMode.ADVANCED && _mouseMode.isEmpty)
    {
      if (structureNode.type != StructureNodeType.NORMAL_NODE && direction == null)
      {
        _mouseMode = new Optional.of(new EditNodeTypeMouseMode(this, structureNode.position));
      }
      else if(direction != null)
      {
        _mouseMode = new Optional.of(new EditBarrierMouseMode(this));
      }
    }
    _mouseMode.ifPresent((mouseMode) => mouseMode.evaluateNodePart(structureNode.position, direction: direction));
  }

  void componentWillUnmount()
  {
    componentWillUnmount();
    _onDocumentMouseUpListener.cancel();
  }
}