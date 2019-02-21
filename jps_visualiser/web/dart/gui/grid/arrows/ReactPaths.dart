import '../../../general/transfer/StoreTransferAble.dart';
import '../../../general/geo/Size.dart';
import '../../../model/history/Highlight.dart';
import '../../../model/store/Store.dart';
import '../arrows/ReactArrow.dart';
import 'package:over_react/over_react.dart';
// ignore: uri_has_not_been_generated
part 'ReactPaths.over_react.g.dart';

@Factory()
UiFactory<ReactPathsProps> ReactPaths = _$ReactPaths;

@Props()
class _$ReactPathsProps extends UiProps
{
  Store store;
}

@Component()
class ReactPathsComponent extends UiComponent<ReactPathsProps>
{
  EqualListener listener;

  Size get size => props.store.size;

  List<Highlight> get backgroundHighlights => props.store.getCurrentStepHighlights(null, "background");
  List<Highlight> get foregroundHighlights => props.store.getCurrentStepHighlights(null, props.store.currentStepDescriptionHoverId);

  Iterable<Highlight> get highlights => backgroundHighlights..addAll(foregroundHighlights);
  Iterable<PathHighlight> get pathHighlights => highlights.map((h) => h as PathHighlight);

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = () => redraw();
    props.store.addEqualListener(["size", "currentStepHighlights_null", "currentStepDescriptionHoverId"], listener);
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
        ..startIntermediate = highlight.startIntermediate
        ..endIntermediate = highlight.endIntermediate
        ..path = highlight.path
        ..wrap = wrap
      )();
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.store.removeEqualListener(listener);
  }
}