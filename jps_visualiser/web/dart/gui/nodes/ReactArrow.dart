import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../../general/Size.dart';
import 'package:over_react/over_react.dart';
import 'package:vector_math/vector_math.dart';

@Factory()
UiFactory<ReactArrowProps> ReactArrow;

@Props()
class ReactArrowProps extends UiProps
{
  Size size;
  Position sourceNode;
  Position targetNode;
  bool showEnd;
}

@Component()
class ReactArrowComponent extends UiComponent<ReactArrowProps>
{
  @override
  getDefaultProps() => (newProps()
    ..showEnd = false
  );

  @override
  ReactElement render()
  {
    Vector2 start = new Vector2(props.sourceNode.x + 0.0, props.sourceNode.y + 0.0);
    Vector2 end = new Vector2(props.targetNode.x + 0.0, props.targetNode.y + 0.0);
    Vector2 direction = (end - start).normalized();

    Vector2 vB = direction * -1.0;
    Vector2 vP90 = vB.clone();
    Vector2 vM90 = new Vector2(dM90.dx + 0.0, dM90.dy + 0.0);

    double arrowSize = direction.isDiagonal ? 0.15 : 0.1;

    vP90 = (vP90 + vB.normalized()) * arrowSize;
    vM90 = (vM90 + vB.normalized()) * arrowSize;

    return (Dom.div()
      ..className = "arrow"
      ..style =
      {
        "width": "${props.size.width * Settings.nodeSize}px",
        "height": "${props.size.height * Settings.nodeSize}px"
      }
    )(
      (Dom.svg()
        ..className = "svg"
        ..viewBox = "-0.5 -0.5 ${props.size.width} ${props.size.height}"
      )(
          (Dom.polygon()
            ..points = "${start.toSVG()} ${end.toSVG()}"
            ..className = "line"
          )(),
          props.showEnd
              ?
            (Dom.polygon()
              ..points = "${end.toSVG()} ${end.x + vP90.x},${end.y + vP90.y} ${end.x + vM90.x},${end.y + vM90.y}"
              ..className = "end"
            )()
              :
              ""
      ),
    );
  }
}