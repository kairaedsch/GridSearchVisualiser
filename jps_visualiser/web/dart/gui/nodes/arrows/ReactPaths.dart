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
    return
      (Dom.div()
        ..className = "paths"
      )(
          props.store.highlights.map(_renderPath).toList()
      );
  }

  ReactElement _renderPath(Highlight highlight)
  {
    if (highlight is PathHighlight)
    {
      return
        (ReactPath()
          ..className = "highlight_${highlight.style}"
          ..key = highlight.hashCode
          ..size = props.storeGridSettings.size
          ..showStart = highlight.showStart
          ..showEnd = highlight.showEnd
          ..path = highlight.path
        )();
    }

    return null;
  }
}