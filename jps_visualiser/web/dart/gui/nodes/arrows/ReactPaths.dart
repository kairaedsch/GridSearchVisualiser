import '../../../futuuure/general/DataTransferAble.dart';
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
  SimpleListener listener;

  Size get size => props.data.size;

  List<Highlight> get backgroundHighlights => props.data.getCurrentStepHighlights(null, "background");
  List<Highlight> get foregroundHighlights => props.data.getCurrentStepHighlights(null, props.data.currentStepDescriptionHoverId);

  Iterable<Highlight> get highlights => backgroundHighlights..addAll(foregroundHighlights);
  Iterable<PathHighlight> get pathHighlights => highlights.map((h) => h as PathHighlight);

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = () => redraw();
    props.data.addSimpleListener(["currentStepHighlights_null", "currentStepDescriptionHoverId"], listener);
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
                pathHighlights.map((highlight) => renderPathHighlight(highlight, size, false)).toList()
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

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.data.removeSimpleListener(listener);
  }
}