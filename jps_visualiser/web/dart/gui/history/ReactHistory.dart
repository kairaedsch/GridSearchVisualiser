import '../../model/history/Explanation.dart';
import '../../store/grid/StoreGrid.dart';
import '../../store/history/History.dart';
import '../../store/history/StoreHistory.dart';
import '../../store/history/HistoryPart.dart';
import 'ReactExplanationPart.dart';
import 'package:over_react/over_react.dart';
import 'package:quiver/core.dart';

@Factory()
UiFactory<ReactHistoryProps> ReactHistory;

@Props()
class ReactHistoryProps extends FluxUiProps<ActionsHistory, StoreHistory>
{

}

@Component()
class ReactHistoryComponent extends FluxUiComponent<ReactHistoryProps>
{
  @override
  ReactElement render()
  {
    if (props.store.history.isEmpty)
    {
      return (Dom.div()..className = "history")();
    }

    History history = props.store.history.value;
    Optional<HistoryPart> historyPart = props.store.active;

    return
      (Dom.div()..className = "history")(
        (Dom.div()..className = "title")(
            history.title
        ),
        (Dom.div()..className = "parts"
          " ${historyPart.isEmpty ? "turnOverviewEmpty" : ""}"
        )(
            history.parts.map((p) => _renderPart(p))
        ),
        historyPart.isEmpty
          ?
        (Dom.div()..className = "turnOverview")(
            (Dom.div()..className = "title")(
                "Select a step to see futher informations about it here"
            )
        )
          :
        (Dom.div()..className = "turnOverview")(
            (Dom.div()..className = "title")(
                _renderExplanation(historyPart.value.title)
            ),
            (Dom.div()..className = "description")(
                _renderExplanations(historyPart.value.description)
            )
        )
      );
  }

  ReactElement _renderPart(HistoryPart part)
  {
    bool selected = (props.store.active.isPresent && part == props.store.active.value);
    return
      (Dom.div()
        ..key = part.turn
        ..className = "part"
            " ${selected ? "selected" : ""}"
        ..onClick = ((_) => props.store.actions.activeChanged.call(selected ? const Optional.absent() : new Optional.of(part)))
      )(part.turn);
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
          " ${explanation.style.or("")}"
        ..key = explanation.hashCode
      )(
          explanation.explanation.map((ep)
          {
            return
              (ReactExplanationPart()
                ..explanationPart = ep
                ..key = ep.hashCode
                ..actionsHistory = props.actions
              )();
          }).toList()
      );
  }
}