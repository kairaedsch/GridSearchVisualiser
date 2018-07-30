import '../../../general/Position.dart';
import '../../../general/Settings.dart';
import '../../../general/Size.dart';
import 'ReactArrow.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactPathProps> ReactPath;

@Props()
class ReactPathProps extends UiProps
{
  Size size;
  List<Position> path;
  bool showEnd;
  bool showStart;
  bool wrap;
}

@Component()
class ReactPathComponent extends UiComponent<ReactPathProps>
{
  @override
  getDefaultProps() =>
      (newProps()
        ..showEnd = false
        ..showStart = false
        ..wrap = true
      );

  @override
  ReactElement render()
  {
    List<ReactElement> arrows = [];
    for (int i = 0; i < props.path.length - 1; i++)
    {
      bool start = (i == 0);
      bool end = (i + 1 == props.path.length - 1);

      arrows.add(
          (ReactArrow()
            ..key = i
            ..size = props.size
            ..sourceNode = props.path[i]
            ..targetNode = props.path[i + 1]
            ..showStart = props.showStart && start
            ..showEnd = props.showEnd && end
            ..startIntermediate = start ? 1.0 : 0.0
            ..endIntermediate = end ? 1.0 : 0.0
            ..wrap = false
          )()
      );
    }

    if (!props.wrap)
    {
      return (Dom.g()..className = props.className)(arrows);
    }
    else
    {
      return
        (Dom.div()
          ..className = "path"
        )(
          (Dom.div()
            ..className = "nodeArrow"
            ..style =
            <String, String>{
              "width": "${props.size.width * Settings.nodeSize}px",
              "height": "${props.size.height * Settings.nodeSize}px"
            }
          )(
            (Dom.svg()
              ..className = "svg"
              ..viewBox = "-0.5 -0.5 ${props.size.width} ${props.size.height}"
            )(
                arrows
            ),
          )
        );
    }
  }
}