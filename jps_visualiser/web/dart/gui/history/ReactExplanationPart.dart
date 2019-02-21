import '../../general/general/Util.dart';
import '../../model/store/Store.dart';
import '../../model/history/Explanation.dart';
import 'package:over_react/over_react.dart';
// ignore: uri_has_not_been_generated
part 'ReactExplanationPart.over_react.g.dart';

@Factory()
UiFactory<ReactExplanationPartProps> ReactExplanationPart = _$ReactExplanationPart;

@Props()
class _$ReactExplanationPartProps extends UiProps
{
  ExplanationPart explanationPart;
  Store store;
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
            props.store.currentStepDescriptionHoverId = explanationPart.id;
            props.store.triggerTransferListeners();
          }
          ..onMouseLeave = (_) {
            if (props.store.currentStepDescriptionHoverId == explanationPart.id)
            {
              Util.print("currentStepDescriptionHoverId = foreground");
              props.store.currentStepDescriptionHoverId = "foreground";
              props.store.triggerTransferListeners();
            }
          }
      )(
          explanationPart.text
      );
  }
}