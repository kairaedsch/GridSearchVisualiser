import '../../futuuure/transfer/Data.dart';
import '../../model/history/Explanation.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactExplanationPartProps> ReactExplanationPart;

@Props()
class ReactExplanationPartProps extends UiProps
{
  ExplanationPart explanationPart;
  Data data;
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
          " ${explanationPart.style != "" ? "styled highlight_${explanationPart.style}" : "unstyled"}"
          ..onMouseEnter = (
                  (_) => null //props.actionsHistory.customHighlightsChanged.call(explanationPart.highlights)
          )
          ..onMouseLeave = (
                  (_) => null //props.actionsHistory.customHighlightsChanged.call([])
          )
      )(
          explanationPart.text
      );
  }
}