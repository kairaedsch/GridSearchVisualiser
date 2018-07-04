import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../../general/Size.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactArrowProps> ReactArrow;

@Props()
class ReactArrowProps extends UiProps
{
  Size size;
  Position sourceNode;
  Position targetNode;
}

@Component()
class ReactArrowComponent extends UiComponent<ReactArrowProps>
{
  @override
  ReactElement render()
  {
    Position start = props.sourceNode;
    Position end = props.targetNode;

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
          (Dom.line()
            ..x1 = start.x
            ..y1 = start.y
            ..x2 = end.x
            ..y2 = end.y
            ..className = "line"
          )(),
         (Dom.polygon()
             ..points = "1,1 2,2 1,1"
             ..className = "end"
         )()
      ),
    );
  }
}