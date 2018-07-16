import '../../../general/Position.dart';
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
}

@Component()
class ReactPathComponent extends UiComponent<ReactPathProps>
{
  @override
  getDefaultProps() =>
      (newProps()
        ..showEnd = false
        ..showStart = false
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
          )()
      );
    }

    return
      (Dom.div()
        ..className = "path ${props.className}"
      )(
          arrows
      );
  }
}