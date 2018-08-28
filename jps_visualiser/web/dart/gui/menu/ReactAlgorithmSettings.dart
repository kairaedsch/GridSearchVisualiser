import '../../general/Bool.dart';
import '../../general/gui/DropDownElement.dart';
import '../ReactMain.dart';
import '../../store/StoreAlgorithmSettings.dart';
import '../../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import 'package:over_react/over_react.dart';
import 'dart:html';

@Factory()
UiFactory<ReactAlgorithmSettingsProps> ReactAlgorithmSettings;

@Props()
class ReactAlgorithmSettingsProps extends FluxUiProps<ActionsAlgorithmSettingsChanged, StoreAlgorithmSettings>
{
  Function runAlgorithm;
}

@Component()
class ReactAlgorithmSettingsComponent extends FluxUiComponent<ReactAlgorithmSettingsProps>
{
  @override
  ReactElement render()
  {
    return
      (Dom.div()..className = "menu")(
        (Dom.div()..className = "title")("Algorithm settings"),
        (Dom.div()..className = "configs")(
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Algorithm:"),
              (ReactDropDown()
                ..value = props.store.algorithmType
                ..values = AlgorithmType.values
                ..selectListener = ((newValue) => props.store.actions.algorithmTypeChanged.call(newValue as AlgorithmType))
              )()
          ),
          (props.store.algorithmType != AlgorithmType.DIJKSTRA && props.store.algorithmType != AlgorithmType.JPS_DATA) ?
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Heuristic:"),
              (ReactDropDown()
                ..value = props.store.heuristicType
                ..values = HeuristicType.values
                ..selectListener = ((newValue) => props.store.actions.heuristicTypeChanged.call(newValue as HeuristicType))
              )()
          ) : (Dom.div()..className = "config")(),
          (Dom.div()..className = "config")(
              (Dom.div()
                ..className = "button"
                ..onClick = ((_) => props.runAlgorithm())
              )("run algorithm"),
          ),
        )
    );
  }
}