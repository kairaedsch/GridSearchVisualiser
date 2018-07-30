import '../../../general/Settings.dart';
import '../../../general/Size.dart';
import '../../../model/history/Highlight.dart';
import '../../../store/StoreGridSettings.dart';
import '../../../store/grid/StorePaths.dart';
import '../arrows/ReactPath.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactPathsProps> ReactPaths;

@Props()
class ReactPathsProps extends FluxUiProps<ActionsPathsChanged, StorePaths>
{
  StoreGridSettings storeGridSettings;
}

@Component()
class ReactPathsComponent extends FluxUiComponent<ReactPathsProps>
{
  @override
  ReactElement render()
  {
    Size size = props.storeGridSettings.size;
    return
      (Dom.div()
        ..className = "paths"
      )(
        (Dom.div()
        ..className = "path"
        )(
          (Dom.div()
            ..className = "nodeArrow"
            ..style =
            <String, String>{
            "width": "${size.width * Settings.nodeSize}px",
            "height": "${size.height * Settings.nodeSize}px"
          }
          )(
            (Dom.svg()
            ..className = "svg"
            ..viewBox = "-0.5 -0.5 ${size.width} ${size.height}"
            )(
                props.store.highlights.map(_renderPath).toList()
            ),
          )
        )
      );
  }

  ReactElement _renderPath(PathHighlight highlight)
  {
    return
      (ReactPath()
        ..className = "pathHighlight highlight_${highlight.style}"
        ..key = highlight.hashCode
        ..size = props.storeGridSettings.size
        ..showStart = highlight.showStart
        ..showEnd = highlight.showEnd
        ..path = highlight.path
        ..wrap = false
      )();
  }
}