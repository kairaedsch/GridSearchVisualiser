import '../../general/transfer/StoreTransferAble.dart';
import '../../general/geo/Direction.dart';
import '../../model/store/Store.dart';
import '../../model/store/Enums.dart';
import '../../general/geo/Position.dart';
import '../../general/geo/Size.dart';
import 'mouse.mode/EditBarrierMouseMode.dart';
import 'mouse.mode/EditNodeTypeMouseMode.dart';
import 'mouse.mode/MouseMode.dart';
import 'ReactNode.dart';
import 'dart:async';
import 'dart:html';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';
import 'dart:math';
import 'dart:js';
// ignore: uri_has_not_been_generated
part 'ReactGrid.over_react.g.dart';

@Factory()
UiFactory<ReactGridProps> ReactGrid = _$ReactGrid;

@Props()
class _$ReactGridProps extends UiProps
{
  Store store;
}

@Component()
class ReactGridComponent extends UiComponent<ReactGridProps>
{
  EqualListener listener;

  Size get size => props.store.size;

  Optional<MouseMode> _mouseMode;
  Optional<MouseMode> get mouseMode => _mouseMode;

  StreamSubscription _onDocumentMouseUpListener;

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    _mouseMode = const Optional.absent();
    _onDocumentMouseUpListener = window.document.onMouseUp.listen((event) => _mouseMode = const Optional.absent());

    window.addEventListener("resize", (e) => _updateCSSVariables());

    listener = () => redraw();
    props.store.addEqualListener(["size", "gridMode", "directionMode", "cornerMode", "directionalMode"], listener);
  }

  @override
  ReactElement render()
  {
    _updateCSSVariables();
    return
      (Dom.div()
        ..className = "grid"
            " GRID_MODE_${Enums.toName(props.store.gridMode)}"
            " DIRECTION_MODE_${Enums.toName(props.store.directionMode)}"
            " CROSS_CORNER_${Enums.toName(props.store.cornerMode)}"
            " WAY_MODE_${Enums.toName(props.store.directionalMode)}"
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
    return
      (ReactNode()
        ..key = pos
        ..position = pos
        ..store = props.store
        ..grid = this
      )();
  }

  void updateMouseModeFromNode(Position position)
  {
    if (props.store.gridMode == GridMode.BASIC && _mouseMode.isEmpty)
    {
      if (props.store.startPosition == position || props.store.targetPosition == position)
      {
        _mouseMode = new Optional.of(new EditNodeTypeMouseMode(this, position));
      }
      else
      {
        _mouseMode = new Optional.of(new EditBarrierMouseMode(this));
      }
    }
    _mouseMode.ifPresent((mouseMode) => mouseMode.evaluateNode(position));
  }

  void updateMouseModeFromNodePart(Position position, {Direction direction})
  {
    if (props.store.gridMode != GridMode.BASIC && _mouseMode.isEmpty)
    {
      if ((props.store.startPosition == position || props.store.targetPosition == position) && direction == null)
      {
        _mouseMode = new Optional.of(new EditNodeTypeMouseMode(this, position));
      }
      else if (direction != null)
      {
        _mouseMode = new Optional.of(new EditBarrierMouseMode(this));
      }
    }
    _mouseMode.ifPresent((mouseMode) => mouseMode.evaluateNodePart(position, direction: direction));
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();
    _onDocumentMouseUpListener.cancel();

    props.store.removeEqualListener(listener);
  }
}