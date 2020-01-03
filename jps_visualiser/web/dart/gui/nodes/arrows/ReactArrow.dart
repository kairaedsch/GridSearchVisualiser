import '../../../general/Position.dart';
import '../../../general/Size.dart';
import 'package:over_react/over_react.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math';

@Factory()
UiFactory<ReactArrowProps> ReactArrow;

@Props()
class ReactArrowProps extends UiProps
{
  Size size;
  List<Position> path;
  bool showStart;
  bool showEnd;
  double startIntermediate;
  double endIntermediate;
  bool wrap;
}

@Component()
class ReactArrowComponent extends UiComponent<ReactArrowProps>
{
  double arrowSize = 0.1;
  double arrowInset = 0.25;

  @override
  getDefaultProps() =>
      (newProps()
        ..showStart = false
        ..showEnd = false
        ..startIntermediate = 1.0
        ..endIntermediate = 1.0
        ..wrap = true
      );

  @override
  ReactElement render()
  {
    if (props.path.length < 2)
    {
      return null;
    }

    Vector2 startOrg = new Vector2(props.path.first.x + 0.0, props.path.first.y + 0.0);
    Vector2 startEndOrg = new Vector2(props.path[1].x + 0.0, props.path[1].y + 0.0);
    Vector2 endOrg = new Vector2(props.path.last.x + 0.0, props.path.last.y + 0.0);
    Vector2 endStartOrg = new Vector2(props.path[props.path.length - 2].x + 0.0, props.path[props.path.length - 2].y + 0.0);

    Vector2 v = (startEndOrg - startOrg).normalized();
    Vector2 vP90 = rotate(v, 35.0);
    Vector2 vM90 = rotate(v, -35.0);

    Vector2 vB = (endStartOrg - endOrg).normalized();
    Vector2 vBP90 = rotate(vB, 35.0);
    Vector2 vBM90 = rotate(vB, -35.0);

    vBP90 = (vBP90 + vB.normalized()) * arrowSize;
    vBM90 = (vBM90 + vB.normalized()) * arrowSize;

    vP90 = (vP90 + v.normalized()) * arrowSize;
    vM90 = (vM90 + v.normalized()) * arrowSize;

    Vector2 start = startOrg + (v * arrowInset) * props.startIntermediate;
    Vector2 end = endOrg + (vB * arrowInset) *  props.endIntermediate;

    List<Position> intermediatePath = props.path.sublist(1)..removeLast();

    List<ReactElement> svgs =
    [
      (Dom.polyline()
        ..key = "line"
        ..points = ""
            " ${start.x},${start.y}"
            " ${intermediatePath.map((p) => "${p.x},${p.y}").join(" ")}"
            " ${end.x},${end.y}"
        ..className = "line"
      )(),
      props.showEnd
      ?
      (Dom.polygon()
        ..key = "arrowEnd"
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
        ..key = "arrowStart"
        ..points = ""
        " ${start.x},${start.y}"
        " ${start.x + vP90.x},${start.y + vP90.y}"
        " ${start.x + vM90.x},${start.y + vM90.y}"
        ..className = "end"
      )()
          :
      null
    ];

    if (!props.wrap)
    {
      return (Dom.g()..className = props.className)(svgs);
    }
    else
    {
      return
        (Dom.div()
          ..className = "nodeArrow"
        )(
          (Dom.svg()
            ..className = "svg"
            ..viewBox = "-0.5 -0.5 ${props.size.width} ${props.size.height}"
          )(
            (Dom.g()..className = props.className)(svgs)
          ),
        );
    }
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