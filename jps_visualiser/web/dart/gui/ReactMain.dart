import '../general/Save.dart';
import '../store/grid/StorePaths.dart';
import 'dart:html';
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
          ..storeGrid = storeGrid
          ..store = storePaths
          ..actions = storePaths.actions
        )()
      ),
      (Dom.div()..className = "rightContent")(
        (Dom.div()..className = "gridSettingsContainer")(
            (ReactGridSettings()
              ..store = storeGridSettings
              ..actions = storeGridSettings.actions
              ..smallerGrid = storeGrid.smaller
              ..biggerGrid = storeGrid.bigger
              ..download = _download
              ..load = _load
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

  void _download()
  {
    StoreGrid storeGrid = props.store.storeGrid;
    StoreGridSettings storeGridSettings = props.store.storeGridSettings;
    StoreAlgorithmSettings storeAlgorithmSettings = props.store.storeAlgorithmSettings;
    Save save = new Save(storeGrid.size);
    storeGrid.save(save);
    storeGridSettings.save(save);
    storeAlgorithmSettings.save(save);

    AnchorElement link = new AnchorElement();
    link.href = save.downloadLink();
    link.download = "grid.png";
    link.style.display = "false";
    querySelector('body').append(link);
    link.click();
  }

  void _load(String imageData)
  {
    StoreGrid storeGrid = props.store.storeGrid;
    StoreGridSettings storeGridSettings = props.store.storeGridSettings;
    StoreAlgorithmSettings storeAlgorithmSettings = props.store.storeAlgorithmSettings;

    new Save.load(imageData, (save) {
      storeGrid.load(save);
      storeGridSettings.load(save);
      storeAlgorithmSettings.load(save);
    });
  }
}