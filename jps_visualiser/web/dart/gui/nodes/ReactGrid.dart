import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../store/StoreGridSettings.dart';
import '../../store/grid/StoreNode.dart';
import '../../store/grid/StoreGrid.dart';
import '../../store/grid/StructureNode.dart';
import 'EditBarrierMouseMode.dart';
import 'EditNodeTypeMouseMode.dart';
import 'MouseMode.dart';
import 'ReactNode.dart';
import 'dart:async';
import 'dart:html';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';
import 'dart:math';
import 'dart:js';

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
  Size get size => props.store.size;

  Optional<MouseMode> _mouseMode;

  Optional<MouseMode> get mouseMode => _mouseMode;

  StreamSubscription _onDocumentMouseUpListener;

  ReactGridComponent()
  {
    _mouseMode = const Optional.absent();
  }

  void componentWillMount()
  {
    super.componentWillMount();
    _onDocumentMouseUpListener = window.document.onMouseUp.listen((event) => _mouseMode = const Optional.absent());
    window.addEventListener("resize", (e) => _updateCSSVariables());
  }

  @override
  List<Store> redrawOn() {
    return [props.store, props.storeGridSettings];
  }

  @override
  ReactElement render()
  {
    _updateCSSVariables();
    return
      (Dom.div()
        ..className = "grid"
            " GRID_MODE_${props.storeGridSettings.gridMode.name}"
            " DIRECTION_MODE_${props.storeGridSettings.directionMode.name}"
            " CROSS_CORNER_${props.storeGridSettings.cornerMode.name}"
            " WAY_MODE_${props.storeGridSettings.directionalMode.name}"
      )(
          (Dom.div()
            ..className = "nodes")(
              new List<ReactElement>.generate(size.height, _renderRow)
          )
      );
  }

  void _updateCSSVariables()
  {
    double gridWidthAvailable = 100 * 0.6;
    double gridHeightAvailable = 100 * (window.innerHeight / window.innerWidth);
    double nodeSizeWidthAvailable = gridWidthAvailable / size.width;
    double nodeSizeHeightAvailable = gridHeightAvailable / size.height;
    double nodeSize = min(nodeSizeWidthAvailable, nodeSizeHeightAvailable);
    double gridWidth = nodeSize * size.width;
    double gridHeight = nodeSize * size.height;

    _setCSSVariable("--grid-width", "${gridWidth}vw");
    _setCSSVariable("--grid-height", "${gridHeight}vw");
    _setCSSVariable("--node-size", "${nodeSize}vw");
    _setCSSVariable("--node-part-size", "calc(var(--node-size) / 3)");
    _setCSSVariable("--node-part-size-inner-padding", "${nodeSize * 0.02}vw");
    _setCSSVariable("--node-part-size-inner", "calc(var(--node-size) / 3 - 2 * var(--node-part-size-inner-padding))");
  }

  void _setCSSVariable(String name, String value)
  {
    context.callMethod("eval", <String>["document.documentElement.style.setProperty('$name', '$value');"]);
  }

  ReactElement _renderRow(int y)
  {
    return
      (Dom.div()
        ..className = "row"
        ..key = y
      )(
          new List<ReactElement>.generate(size.width, (x) => _renderNode(new Position(x, y)))
      );
  }

  ReactElement _renderNode(Position pos)
  {
    StoreNode storeNode = props.store[pos];

    return
      (ReactNode()
        ..key = pos
        ..storeGridSettings = props.storeGridSettings
        ..storeGrid = props.store
        ..store = storeNode
        ..actions = storeNode.actions
        ..grid = this
      )();
  }

  void updateMouseModeFromNode(StoreNode storeNode)
  {
    if (props.storeGridSettings.gridMode == GridMode.BASIC && _mouseMode.isEmpty)
    {
      if (storeNode.structureNode.type != StructureNodeType.NORMAL_NODE)
      {
        _mouseMode = new Optional.of(new EditNodeTypeMouseMode(this, storeNode.position));
      }
      else
      {
        _mouseMode = new Optional.of(new EditBarrierMouseMode(this));
      }
    }
    _mouseMode.ifPresent((mouseMode) => mouseMode.evaluateNode(storeNode.position));
  }

  void updateMouseModeFromNodePart(StoreNode storeNode, {Direction direction})
  {
    if (props.storeGridSettings.gridMode != GridMode.BASIC && _mouseMode.isEmpty)
    {
      if (storeNode.structureNode.type != StructureNodeType.NORMAL_NODE && direction == null)
      {
        _mouseMode = new Optional.of(new EditNodeTypeMouseMode(this, storeNode.position));
      }
      else if (direction != null)
      {
        _mouseMode = new Optional.of(new EditBarrierMouseMode(this));
      }
    }
    _mouseMode.ifPresent((mouseMode) => mouseMode.evaluateNodePart(storeNode.position, direction: direction));
  }

  void componentWillUnmount()
  {
    super.componentWillUnmount();
    _onDocumentMouseUpListener.cancel();
  }
}