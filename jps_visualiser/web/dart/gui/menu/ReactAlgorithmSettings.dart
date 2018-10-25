import '../../futuuure/transfer/Data.dart';
import '../../futuuure/transfer/GridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import '../../general/gui/ReactPopover.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactAlgorithmSettingsProps> ReactAlgorithmSettings;

@Props()
class ReactAlgorithmSettingsProps extends UiProps
{
  Data data;
  Function runAlgorithm;
}

@Component()
class ReactAlgorithmSettingsComponent extends UiComponent<ReactAlgorithmSettingsProps>
{
  @override
  ReactElement render()
  {
    bool useHeuristic = (props.data.algorithmType != AlgorithmType.DIJKSTRA && props.data.algorithmType != AlgorithmType.JPSP_DATA);
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
                ..value = props.data.algorithmType
                ..values = AlgorithmType.values
                ..getTitle = AlgorithmTypes.getTitle
                ..selectListener = ((dynamic newValue) => props.data.algorithmType = newValue as AlgorithmType)
              )()
          ),
          useHeuristic ?
          (ReactPopover()
            ..className = "config"
            ..popover = "Select the heuristic to be used by the algorithm"
          )(
              (Dom.div()..className = "title")("Heuristic:"),
              (ReactDropDown()
                ..value = props.data.heuristicType
                ..values = HeuristicType.values
                ..getTitle = HeuristicTypes.getTitle
                ..selectListener = ((dynamic newValue) => props.data.heuristicType = newValue as HeuristicType)
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