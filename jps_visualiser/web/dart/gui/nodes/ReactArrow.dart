import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../../general/Size.dart';
import 'package:over_react/over_react.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math';

@Factory()
UiFactory<ReactArrowProps> ReactArrow;

@Props()
class ReactArrowProps extends UiProps
{
  Size size;
  Position sourceNode;
  Position targetNode;
  bool showEnd;
  bool showStart;
}

@Component()
class ReactArrowComponent extends UiComponent<ReactArrowProps>
{
  double arrowSize = 0.1;
  double arrowInset = 0.15;

  @override
  getDefaultProps() =>
      (newProps()
        ..showEnd = false
        ..showStart = false
      );

  @override
  ReactElement render()
  {
    Vector2 startOrg = new Vector2(props.sourceNode.x + 0.0, props.sourceNode.y + 0.0);
    Vector2 endOrg = new Vector2(props.targetNode.x + 0.0, props.targetNode.y + 0.0);

    Vector2 v = (endOrg - startOrg).normalized();
    Vector2 vP90 = rotate(v, 35.0);
    Vector2 vM90 = rotate(v, -35.0);

    Vector2 vB = v * -1.0;
    Vector2 vBP90 = rotate(vB, 35.0);
    Vector2 vBM90 = rotate(vB, -35.0);

    Vector2 start = startOrg + (v * arrowInset);
    Vector2 end = endOrg + (vB * arrowInset);

    vBP90 = (vBP90 + vB.normalized()) * arrowSize;
    vBM90 = (vBM90 + vB.normalized()) * arrowSize;

    vP90 = (vP90 + v.normalized()) * arrowSize;
    vM90 = (vM90 + v.normalized()) * arrowSize;

    return
      (Dom.div()
        ..className = "nodeArrow"
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
              ..points = ""
                  " ${start.x},${start.y}"
                  " ${end.x},${end.y}"
              ..className = "line"
            )(),
            props.showEnd
                ?
            (Dom.polygon()
              ..points = ""
                  " ${end.x},${end.y}"
                  " ${end.x + vBP90.x},${end.y + vBP90.y}"
                  " ${end.x + vBM90.x},${end.y + vBM90.y}"
              ..className = "end"
            )()
                :
            null,
            props.showStart
                ?
            (Dom.polygon()
              ..points = ""
                  " ${start.x},${start.y}"
                  " ${start.x + vP90.x},${start.y + vP90.y}"
                  " ${start.x + vM90.x},${start.y + vM90.y}"
              ..className = "end"
            )()
                :
            null
        ),
      );
  }

  Vector2 rotate(Vector2 vec, double angle)
  {
    double theta = degrees(angle);

    double cs = cos(theta);
    double sn = sin(theta);

    double x = vec.x * cs - vec.y * sn;
    double y = vec.x * sn + vec.y * cs;

    return new Vector2(x, y);
  }
}