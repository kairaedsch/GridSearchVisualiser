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
            )()
        ),
        (Dom.div()..className = "stepsContainer")()
      )
    );
  }
}