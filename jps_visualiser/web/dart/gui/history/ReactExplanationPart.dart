import '../../model/history/Explanation.dart';
import '../store/grid/StoreGrid.dart';
import '../store/history/History.dart';
import '../store/history/StoreHistory.dart';
import '../store/history/HistoryPart.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

@Factory()
UiFactory<ReactExplanationPartProps> ReactExplanationPart;

@Props()
class ReactExplanationPartProps extends UiProps
{
  ExplanationPart explanationPart;
  StoreGrid storeGrid;
}

@Component()
class ReactExplanationPartComponent extends UiComponent<ReactExplanationPartProps>
{
  @override
  ReactElement render()
  {
    ExplanationPart explanationPart = props.explanationPart;

    return
      (Dom.div()
        ..className = "explanationPart"
          " ${explanationPart.type.isPresent ? "typed" : "untyped"}"
          " ${explanationPart.type.or("")}"
          ..onMouseEnter = ((_) => _highlightNodes(true))
          ..onMouseLeave = ((_) => _highlightNodes(false))
      )(
          explanationPart.text
      );
  }

  void _highlightNodes(bool highlight)
  {
    ExplanationPart explanationPart = props.explanationPart;

    props.explanationPart.nodes.forEach((p) => props.storeGrid[p].actions.highlightChanged.call(highlight ? explanationPart.type : const Optional.absent()));
  }
}