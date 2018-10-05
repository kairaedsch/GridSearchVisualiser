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
    bool useHeuristic = (props.store.algorithmType != AlgorithmType.DIJKSTRA && props.store.algorithmType != AlgorithmType.JPSP_DATA);
    return
      (Dom.div()..className = "menu")(
        (Dom.div()..className = "title")("Algorithm"),
        (Dom.div()..className = "configs")(
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Algorithm:"),
              (ReactDropDown()
                ..title = "Select the algorithm to run on the grid"
                ..value = props.store.algorithmType
                ..values = AlgorithmType.values
                ..selectListener = ((newValue) => props.store.actions.algorithmTypeChanged.call(newValue as AlgorithmType))
              )()
          ),
          useHeuristic ?
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Heuristic:"),
              (ReactDropDown()
                ..title = "Select the heuristic to be used by the algorithm"
                ..value = props.store.heuristicType
                ..values = HeuristicType.values
                ..selectListener = ((newValue) => props.store.actions.heuristicTypeChanged.call(newValue as HeuristicType))
              )()
          ) : (Dom.div()..className = "config")(),
          (Dom.div()..className = "config")(
              (Dom.div()
                ..title = "Run the algorithm${useHeuristic ? " with the selected heuristic" : ""}"
                ..className = "button"
                ..onClick = ((_) => props.runAlgorithm())
              )("run algorithm"),
          ),
        )
    );
  }
}