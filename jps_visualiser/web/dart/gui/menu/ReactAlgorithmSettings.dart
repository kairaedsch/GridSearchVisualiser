import '../../general/Bool.dart';
import '../../general/gui/DropDownElement.dart';
import '../ReactMain.dart';
import '../../store/StoreAlgorithmSettings.dart';
import '../../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import '../../general/gui/ReactPopover.dart';
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
          (ReactPopover()
            ..className = "config"
            ..popover = "Select the algorithm to run on the grid"
          )(
              (Dom.div()..className = "title")("Algorithm:"),
              (ReactDropDown()
                ..value = props.store.algorithmType
                ..values = AlgorithmType.values
                ..selectListener = ((newValue) => props.store.actions.algorithmTypeChanged.call(newValue as AlgorithmType))
              )()
          ),
          useHeuristic ?
          (ReactPopover()
            ..className = "config"
            ..popover = "Select the heuristic to be used by the algorithm"
          )(
              (Dom.div()..className = "title")("Heuristic:"),
              (ReactDropDown()
                ..value = props.store.heuristicType
                ..values = HeuristicType.values
                ..selectListener = ((newValue) => props.store.actions.heuristicTypeChanged.call(newValue as HeuristicType))
              )()
          ) : (Dom.div()..className = "config")(),
          (ReactPopover()
            ..className = "config"
            ..popover = "Run the algorithm${useHeuristic ? " with the selected heuristic" : ""}"
          )(
              (Dom.div()
                ..className = "button"
                ..onClick = ((_) => props.runAlgorithm())
              )(
                "Run algorithm"),
          ),
        )
    );
  }
}