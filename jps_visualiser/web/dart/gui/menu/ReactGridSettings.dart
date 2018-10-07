import '../../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import '../../general/gui/ReactPopover.dart';
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
          (ReactPopover()
            ..className = "config"
            ..title = "Select the mode of the grid"
          )(
              (Dom.div()..className = "title")("Mode:"),
              (ReactDropDown()
                ..value = props.store.gridMode
                ..values = GridMode.values
                ..selectListener = ((newValue) => props.store.actions.gridModeChanged.call(newValue as GridMode))
              )()
          ),
          (ReactPopover()
            ..className = "config"
            ..title = "Select which directions are allowed"
          )(
              (Dom.div()..className = "title")("Directions:"),
              (ReactDropDown()
                ..value = props.store.directionMode
                ..values = DirectionMode.values
                ..selectListener = ((newValue) => props.store.actions.directionModeChanged.call(newValue as DirectionMode))
              )()
          ),
          props.store.gridMode != GridMode.BASIC ?
          (ReactPopover()
            ..className = "config"
            ..title = "Select the directional mode"
          )(
              (Dom.div()..className = "title")("Directional:"),
              (ReactDropDown()
                ..value = props.store.directionalMode
                ..values = DirectionalMode.values
                ..selectListener = ((newValue) => props.store.actions.directionalModeChanged.call(newValue as DirectionalMode))
              )()
          ) : null,
          props.store.directionMode != DirectionMode.ONLY_CARDINAL ?
          (ReactPopover()
            ..className = "config"
            ..title = "Select if edges are allowed to cross corners"
          )(
              (Dom.div()..className = "title")("Cross Corners:"),
              (ReactDropDown()
                ..value = props.store.crossCornerMode
                ..values = CrossCornerMode.values
                ..selectListener = ((newValue) => props.store.actions.crossCornerModeChanged.call(newValue as CrossCornerMode))
              )()
          ) : null,
          (ReactPopover()
            ..className = "config icon"
            ..title = "Shrink grid"
          )(
            (Dom.div()
              ..className = "button icon minus"
              ..onClick = ((_) => props.smallerGrid())
            )(" "),
          ),
          (ReactPopover()
            ..className = "config icon"
            ..title = "Enlarge grid"
          )(
            (Dom.div()
              ..className = "button icon plus"
              ..onClick = ((_) => props.biggerGrid())
            )(" "),
          ),
          (ReactPopover()
            ..className = "config icon"
            ..title = "Download grid"
          )(
            (Dom.div()
              ..className = "button icon save"
              ..onClick = ((_) => props.download())
            )(" "),
          ),
          (ReactPopover()
            ..className = "config icon"
            ..title = "Load grid"
          )(
            (Dom.label()
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