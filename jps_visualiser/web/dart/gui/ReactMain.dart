import '../store/grid/StorePaths.dart';
import 'package:over_react/over_react.dart';

import '../store/StoreAlgorithmSettings.dart';
import '../store/StoreGridSettings.dart';
import '../store/grid/StoreGrid.dart';
import '../store/StoreMain.dart';
import '../store/history/StoreHistory.dart';
import 'nodes/ReactGrid.dart';
import 'nodes/arrows/ReactPaths.dart';
import 'menu/ReactGridSettings.dart';
import 'menu/ReactAlgorithmSettings.dart';
import 'history/ReactHistory.dart';

@Factory()
UiFactory<ReactMainProps> ReactMain;

@Props()
class ReactMainProps extends FluxUiProps<ActionsMain, StoreMain>
{

}

@Component()
class ReactMainComponent extends FluxUiComponent<ReactMainProps>
{
  @override
  ReactElement render()
  {
    StoreGrid storeGrid = props.store.storeGrid;
    StoreGridSettings storeGridSettings = props.store.storeGridSettings;
    StoreAlgorithmSettings storeAlgorithmSettings = props.store.storeAlgorithmSettings;
    StoreHistory storeHistory = props.store.storeHistory;
    StorePaths storePaths = props.store.storePaths;

    return (
    Dom.div()..className = "content")(
      (Dom.div()..className = "leftContent")(
        (ReactGrid()
          ..storeGridSettings = storeGridSettings
          ..store = storeGrid
          ..actions = storeGrid.actions
        )(),
        (ReactPaths()
          ..storeGridSettings = storeGridSettings
          ..store = storePaths
          ..actions = storePaths.actions
        )()
      ),
      (Dom.div()..className = "rightContent")(
        (Dom.div()..className = "gridSettingsContainer")(
            (ReactGridSettings()
              ..store = storeGridSettings
              ..actions = storeGridSettings.actions
              ..downloadGrid = storeGrid.downloadGrid
            )()
        ),
        (Dom.div()..className = "algorithmSettingsContainer")(
            (ReactAlgorithmSettings()
              ..store = storeAlgorithmSettings
              ..actions = storeAlgorithmSettings.actions
              ..runAlgorithm = props.store.actions.runAlgorithm.call
            )()
        ),
        (Dom.div()..className = "historyContainer")(
            (ReactHistory()
              ..store = storeHistory
              ..actions = storeHistory.actions
            )()
        )
      )
    );
  }
}