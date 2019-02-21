import '../../general/transfer/StoreTransferAble.dart';
import '../../model/store/Store.dart';
import '../../model/history/Explanation.dart';
import 'ReactExplanationPart.dart';
import 'package:over_react/over_react.dart';
// ignore: uri_has_not_been_generated
part 'ReactHistory.over_react.g.dart';

@Factory()
UiFactory<ReactHistoryProps> ReactHistory = _$ReactHistory;

@Props()
class _$ReactHistoryProps extends UiProps
{
  Store store;
}

@Component()
class ReactHistoryComponent extends UiComponent<ReactHistoryProps>
{
  EqualListener listener;

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = () => redraw();
    props.store.addEqualListener(["title", "stepCount", "currentStepId", "currentStepTitle", "currentStepDescription"], listener);
  }

  @override
  ReactElement render()
  {
    if (props.store.title == "")
    {
      return (Dom.div()..className = "history")();
    }

    return
      (Dom.div()..className = "history")(
        (Dom.div()..className = "title")(
            props.store.title
        ),
        (Dom.div()..className = "parts"
          " ${props.store.stepCount == 0 ? "turnOverviewEmpty" : ""}"
        )(
          new List<ReactElement>.generate(props.store.stepCount, (i) => _renderPart(i))
        ),
          props.store.currentStepId == -1
          ?
        (Dom.div()..className = "turnOverview")(
            (Dom.div()..className = "title")(
                "Select a step to see futher informations about it here"
            )
        )
          :
        (Dom.div()..className = "turnOverview")(
            (Dom.div()..className = "title")(
                props.store.currentStepTitle
            ),
            (Dom.div()..className = "description")(
                _renderExplanations(props.store.currentStepDescription)
            )
        )
      );
  }

  ReactElement _renderPart(int stepId)
  {
    bool selected = props.store.currentStepId == stepId;
    return
      (Dom.div()
        ..key = stepId
        ..className = "part"
            " ${selected ? "selected" : ""}"
        ..onClick = ((_) => props.store.currentStepId = selected ? -1 : stepId)
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
                ..store = props.store
              )();
          }).toList()
      );
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.store.removeEqualListener(listener);
  }
}