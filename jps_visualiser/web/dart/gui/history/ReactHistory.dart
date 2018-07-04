import '../../general/Bool.dart';
import '../ReactMain.dart';
import '../store/StoreAlgorithmSettings.dart';
import '../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import '../store/history/StoreHistory.dart';
import '../store/history/HistoryPart.dart';
import 'package:over_react/over_react.dart';
import 'dart:html';

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
    return (Dom.div()..className = "history")(
      props.store.storeHistoryParts.map((p) => renderPart(p))
    );
  }

  ReactElement renderPart(HistoryPart part)
  {
    return (Dom.div()
      ..key = part.id
      ..className = "part"
        " ${part == props.store.active ? "active" : ""}"
      ..onClick = ((_) => props.store.actions.activeChanged.call(part))
    )("Turn " + part.id.toString());
  }
}