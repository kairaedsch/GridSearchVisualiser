import '../model/SearchHistory.dart';
import '../model/algorithm/Algorithm.dart';
import '../model/heuristics/Heuristic.dart';
import 'package:over_react/over_react.dart';
import 'store/StoreAlgorithmSettings.dart';
import 'store/StoreGridSettings.dart';
import 'store/StoreGrid.dart';
import 'nodes/ReactGrid.dart';
import 'menu/ReactGridSettings.dart';
import 'menu/ReactAlgorithmSettings.dart';

@Factory()
UiFactory<ReactMainProps> ReactMain;

@Props()
class ReactMainProps extends FluxUiProps<ActionsGridSettingsChanged, StoreGridSettings>
{
  StoreGrid storeGrid;
  StoreAlgorithmSettings storeAlgorithmSettings;
}

@Component()
class ReactMainComponent extends FluxUiComponent<ReactMainProps>
{
  @override
  render() {
    StoreGrid storeGrid = props.storeGrid;

    return (
    Dom.div()..id = "content")(
      (Dom.div()..id = "leftContent")(
        (ReactGrid()
          ..storeGridSettings = props.store
          ..store = storeGrid
          ..actions = storeGrid.actions
        )()
      ),
      (Dom.div()..id = "rightContent")(
        (Dom.div()..className = "gridSettingsContainer")(
            (ReactGridSettings()
              ..store = props.store
              ..actions = props.store.actions
            )()
        ),
        (Dom.div()..className = "algorithmSettingsContainer")(
            (ReactAlgorithmSettings()
              ..store = props.storeAlgorithmSettings
              ..actions = props.storeAlgorithmSettings.actions
              ..main = this
            )()
        ),
        (Dom.div()..className = "stepsContainer")()
      )
    );
  }

  void runAlgorithm()
  {
    StoreGrid storeGrid = props.storeGrid;
    StoreAlgorithmSettings storeAlgorithmSettings = props.storeAlgorithmSettings;

    Algorithm algorithm = storeAlgorithmSettings.algorithmType.algorithm;
    Heuristic heuristic = storeAlgorithmSettings.heuristicType.heuristic;

    SearchHistory searchHistory = algorithm.searchP(storeGrid.toGrid(props.store.allowDiagonal.value, props.store.crossCorners.value), storeGrid.sourcePosition, storeGrid.targetPosition, heuristic);
  }
}