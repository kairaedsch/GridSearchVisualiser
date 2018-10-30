import '../../futuuure/general/Util.dart';
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
          ..onMouseOver = (_) {
            Util.print("currentStepDescriptionHoverId = ${explanationPart.id}");
            props.data.currentStepDescriptionHoverId = explanationPart.id;
          }
          ..onMouseLeave = (_) {
            if (props.data.currentStepDescriptionHoverId == explanationPart.id)
            {
              Util.print("currentStepDescriptionHoverId = foreground");
              props.data.currentStepDescriptionHoverId = "foreground";
            }
          }
      )(
          explanationPart.text
      );
  }
}