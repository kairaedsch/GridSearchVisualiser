import '../../model/history/Explanation.dart';
import '../../store/history/StoreHistory.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactExplanationPartProps> ReactExplanationPart;

@Props()
class ReactExplanationPartProps extends UiProps
{
  ExplanationPart explanationPart;
  ActionsHistory actionsHistory;
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
          " ${explanationPart.style.isPresent ? "styled" : "unstyled"}"
          " ${explanationPart.style.or("")}"
          ..onMouseEnter = (
                  (_) => props.actionsHistory.highlightsUpdate.call(explanationPart.highlights)
          )
          ..onMouseLeave = (
                  (_) => props.actionsHistory.highlightsUpdate.call([])
          )
      )(
          explanationPart.text
      );
  }
}