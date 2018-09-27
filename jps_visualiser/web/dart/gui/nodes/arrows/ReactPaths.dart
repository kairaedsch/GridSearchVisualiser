import '../../../general/Size.dart';
import '../../../model/history/Highlight.dart';
import '../../../store/StoreGridSettings.dart';
import '../../../store/grid/StoreGrid.dart';
import '../../../store/grid/StorePaths.dart';
import '../arrows/ReactArrow.dart';
import 'package:over_react/over_react.dart';
import 'package:w_flux/w_flux.dart';

@Factory()
UiFactory<ReactPathsProps> ReactPaths;

@Props()
class ReactPathsProps extends FluxUiProps<ActionsPathsChanged, StorePaths>
{
  StoreGrid storeGrid;
}

@Component()
class ReactPathsComponent extends FluxUiComponent<ReactPathsProps>
{
  Size get size => props.storeGrid.size;

  @override
  List<Store> redrawOn() {
    return [props.store, props.storeGrid];
  }

  @override
  ReactElement render()
  {
    return
      (Dom.div()
        ..className = "paths"
      )(
        (Dom.div()
        ..className = "path"
        )(
          (Dom.div()
            ..className = "nodeArrow"
          )(
            (Dom.svg()
            ..className = "svg"
            ..viewBox = "-0.5 -0.5 ${size.width} ${size.height}"
            )(
                props.store.highlights.map((highlight) => renderPathHighlight(highlight, props.storeGrid.size, false)).toList()
            ),
          )
        )
      );
  }

  static ReactElement renderPathHighlight(PathHighlight highlight, Size size, bool wrap)
  {
    return
      (ReactArrow()
        ..className = "pathHighlight highlight_${highlight.style}"
        ..key = highlight.hashCode
        ..size = size
        ..showStart = highlight.showStart
        ..showEnd = highlight.showEnd
        ..path = highlight.path
        ..wrap = wrap
      )();
  }
}