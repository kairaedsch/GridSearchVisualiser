import '../../general/Bool.dart';
import '../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactGridSettingsProps> ReactGridSettings;

@Props()
class ReactGridSettingsProps extends FluxUiProps<ActionsGridSettingsChanged, StoreGridSettings>
{

}

@Component()
class ReactGridSettingsComponent extends FluxUiComponent<ReactGridSettingsProps>
{
  @override
  ReactElement render()
  {
    return
      (Dom.div()..className = "menu")(
        (Dom.div()..className = "title")("Grid settings"),
        (Dom.div()..className = "configs")(
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Gridmode:"),
              (ReactDropDown()
                ..value = props.store.gridMode
                ..values = GridMode.values
                ..selectListener = ((newValue) => props.store.actions.gridModeChanged.call(newValue))
              )()
          ),
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Allow Diagonal:"),
              (ReactDropDown()
                ..value = props.store.allowDiagonal
                ..values = Bool.values
                ..selectListener = ((newValue) => props.store.actions.allowDiagonalChanged.call(newValue))
              )()
          ),
          props.store.allowDiagonal.value ?
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Cross Corners:"),
              (ReactDropDown()
                ..value = props.store.crossCorners
                ..values = Bool.values
                ..selectListener = ((newValue) => props.store.actions.crossCornersChanged.call(newValue))
              )()
          ) : "",
        )
    );
  }
}