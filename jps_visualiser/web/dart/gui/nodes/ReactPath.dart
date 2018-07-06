import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Settings.dart';
import '../../general/Size.dart';
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
    List<ReactElement> arrows;
    for (int i = 0; i < props.path.length - 1; i++)
    {
      arrows.add(
          (ReactArrow()
            ..size = props.size
            ..sourceNode = props.path[i]
            ..targetNode = props.path[i + 1]
            ..showEnd = i + 1 == props.path.length - 1
          )()
      );
    }

    return (Dom.div()..className = "finalPath")(arrows);
  }
}