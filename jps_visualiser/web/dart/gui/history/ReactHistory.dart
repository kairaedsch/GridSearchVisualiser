import '../../futuuure/general/DataTransferAble.dart';
import '../../futuuure/transfer/Data.dart';
import '../../model/history/Explanation.dart';
import 'ReactExplanationPart.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactHistoryProps> ReactHistory;

@Props()
class ReactHistoryProps extends UiProps
{
  Data data;
}

@Component()
class ReactHistoryComponent extends UiComponent<ReactHistoryProps>
{
  Listener listener;

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = (String key, dynamic oldValue, dynamic newValue) => redraw();
    props.data.addListener(["title", "stepCount", "currentStepId", "currentStepTitle", "currentStepDescription"], listener);
  }

  @override
  ReactElement render()
  {
    if (props.data.title == "")
    {
      return (Dom.div()..className = "history")();
    }

    return
      (Dom.div()..className = "history")(
        (Dom.div()..className = "title")(
            props.data.title
        ),
        (Dom.div()..className = "parts"
          " ${props.data.stepCount == 0 ? "turnOverviewEmpty" : ""}"
        )(
          new List<ReactElement>.generate(props.data.stepCount, (i) => _renderPart(i))
        ),
          props.data.currentStepId == -1
          ?
        (Dom.div()..className = "turnOverview")(
            (Dom.div()..className = "title")(
                "Select a step to see futher informations about it here"
            )
        )
          :
        (Dom.div()..className = "turnOverview")(
            (Dom.div()..className = "title")(
                props.data.currentStepTitle
            ),
            (Dom.div()..className = "description")(
                _renderExplanations(props.data.currentStepDescription)
            )
        )
      );
  }

  ReactElement _renderPart(int stepId)
  {
    bool selected = props.data.currentStepId == stepId;
    return
      (Dom.div()
        ..key = stepId
        ..className = "part"
            " ${selected ? "selected" : ""}"
        ..onClick = ((_) => props.data.currentStepId = selected ? -1 : stepId)
      )(stepId);
  }

  ReactElement _renderExplanations(List<Explanation> explanations)
  {
    return
      (Dom.div()..className = "explanations")(
        explanations.map((e) => _renderExplanation(e))
      );
  }

  ReactElement _renderExplanation(Explanation explanation)
  {
    return
      (Dom.div()
        ..className = "explanation"
          " ${explanation.style}"
        ..key = explanation.hashCode
      )(
          explanation.explanation.map((ep)
          {
            return
              (ReactExplanationPart()
                ..explanationPart = ep
                ..key = ep.hashCode
                ..data = props.data
              )();
          }).toList()
      );
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.data.removeListener(listener);
  }
}