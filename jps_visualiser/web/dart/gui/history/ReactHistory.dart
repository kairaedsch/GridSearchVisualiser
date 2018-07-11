import '../store/history/History.dart';
import '../store/history/StoreHistory.dart';
import '../store/history/HistoryPart.dart';
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
        (Dom.div()..className = "algorithmOverview")(
            history.algorithmOverviewText
        ),
        (Dom.div()..className = "parts")(
            history.parts.map((p) => renderPart(p))
        ),
        historyPart.isEmpty
          ?
        (Dom.div()..className = "turnOverview")("Select a step to see futher informations about it here")
          :
        (Dom.div()..className = "turnOverview")(historyPart.value.title)
      );
  }

  ReactElement renderPart(HistoryPart part)
  {
    bool selected = (props.store.active.isPresent && part == props.store.active.value);
    return
      (Dom.div()
        ..key = part.id
        ..className = "part"
            " ${selected ? "selected" : ""}"
        ..onClick = ((_) => props.store.actions.activeChanged.call(selected ? const Optional.absent() : new Optional.of(part)))
      )(part.id);
  }
}