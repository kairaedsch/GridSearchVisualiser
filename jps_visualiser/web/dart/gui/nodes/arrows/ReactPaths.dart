import '../../../futuuure/transfer/Data.dart';
import '../../../general/Size.dart';
import '../../../model/history/Highlight.dart';
import '../arrows/ReactArrow.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactPathsProps> ReactPaths;

@Props()
class ReactPathsProps extends UiProps
{
  Data data;
}

@Component()
class ReactPathsComponent extends UiComponent<ReactPathsProps>
{
  Size get size => props.data.size;

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
                //props.store.highlights.map((highlight) => renderPathHighlight(highlight, props.storeGrid.size, false)).toList()
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