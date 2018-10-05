import '../../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import 'dart:html';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactGridSettingsProps> ReactGridSettings;

@Props()
class ReactGridSettingsProps extends FluxUiProps<ActionsGridSettingsChanged, StoreGridSettings>
{
  Function download;
  Function load;
  Function smallerGrid;
  Function biggerGrid;
}

@Component()
class ReactGridSettingsComponent extends FluxUiComponent<ReactGridSettingsProps>
{
  @override
  ReactElement render()
  {
    return
      (Dom.div()..className = "menu")(
        (Dom.div()..className = "title")("Grid"),
        (Dom.div()..className = "configs")(
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Mode:"),
              (ReactDropDown()
                ..popover = "Select the basic mode of the grid"
                ..value = props.store.gridMode
                ..values = GridMode.values
                ..selectListener = ((newValue) => props.store.actions.gridModeChanged.call(newValue as GridMode))
              )()
          ),
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Directions:"),
              (ReactDropDown()
                ..popover = "Select which directions are allowed"
                ..value = props.store.directionMode
                ..values = DirectionMode.values
                ..selectListener = ((newValue) => props.store.actions.directionModeChanged.call(newValue as DirectionMode))
              )()
          ),
          props.store.gridMode != GridMode.BASIC ?
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Directional:"),
              (ReactDropDown()
                ..popover = "Select the directional mode"
                ..value = props.store.directionalMode
                ..values = DirectionalMode.values
                ..selectListener = ((newValue) => props.store.actions.directionalModeChanged.call(newValue as DirectionalMode))
              )()
          ) : null,
          props.store.directionMode != DirectionMode.ONLY_CARDINAL ?
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Cross Corners:"),
              (ReactDropDown()
                ..popover = "Select if edges are allowed to cross corners"
                ..value = props.store.crossCornerMode
                ..values = CrossCornerMode.values
                ..selectListener = ((newValue) => props.store.actions.crossCornerModeChanged.call(newValue as CrossCornerMode))
              )()
          ) : null,
          (Dom.div()..className = "config icon")(
            (Dom.div()
              ..title = "Shrink grid"
              ..className = "button icon minus"
              ..onClick = ((_) => props.smallerGrid())
            )(" "),
          ),
          (Dom.div()..className = "config icon")(
            (Dom.div()
              ..title = "Enlarge grid"
              ..className = "button icon plus"
              ..onClick = ((_) => props.biggerGrid())
            )(" "),
          ),
          (Dom.div()..className = "config icon")(
            (Dom.div()
              ..title = "Download grid"
              ..className = "button icon save"
              ..onClick = ((_) => props.download())
            )(" "),
          ),
          (Dom.div()..className = "config icon")(
            (Dom.label()
              ..title = "Load grid"
              ..className = "button icon load"
              ..htmlFor = "load"
            )(" "),
            (Dom.input()
              ..id = "load"
              ..type = "file"
              ..style =
              <String, String>{
                "display": "none",
              }
              ..onChange = (event)
              {
                File file = event.target.files[0] as File;
                FileReader reader = new FileReader();
                reader.onLoadEnd.listen((fileEvent)
                {
                  props.load(reader.result);
                }, onError: (dynamic error) => window.alert("Could not read Grid: ${reader.error.code}"));
                reader.readAsDataUrl(file);
                event.target.value = null;
              }
            )(),
          ),
        )
    );
  }
}