import '../../general/Bool.dart';
import '../store/StoreAlgorithmSettings.dart';
import '../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import 'package:over_react/over_react.dart';
import 'dart:html';

@Factory()
UiFactory<ReactAlgorithmSettingsProps> ReactAlgorithmSettings;

@Props()
class ReactAlgorithmSettingsProps extends FluxUiProps<ActionsAlgorithmSettingsChanged, StoreAlgorithmSettings>
{

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
                ..selectListener = ((newValue) => props.store.actions.algorithmTypeChanged.call(newValue))
              )()
          ),
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Heuristic:"),
              (ReactDropDown()
                ..value = props.store.heuristicType
                ..values = HeuristicType.values
                ..selectListener = ((newValue) => props.store.actions.heuristicTypeChanged.call(newValue))
              )()
          ),
          (Dom.div()..className = "config")(
              (Dom.div()
                ..className = "button"
                ..onClick = ((_) => window.alert("starting...."))
              )("run algorithm"),
          ),
        )
    );
  }
}