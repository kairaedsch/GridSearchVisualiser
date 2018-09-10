import '../../store/StoreGridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import 'dart:html';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactGridSettingsProps> ReactGridSettings;

@Props()
class ReactGridSettingsProps extends FluxUiProps<ActionsGridSettingsChanged, StoreGridSettings>
{
  Function downloadGrid;
  Function loadGrid;
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
                ..value = props.store.gridMode
                ..values = GridMode.values
                ..selectListener = ((newValue) => props.store.actions.gridModeChanged.call(newValue as GridMode))
              )()
          ),
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Directions:"),
              (ReactDropDown()
                ..value = props.store.directionMode
                ..values = DirectionMode.values
                ..selectListener = ((newValue) => props.store.actions.directionModeChanged.call(newValue as DirectionMode))
              )()
          ),
          props.store.gridMode != GridMode.BASIC ?
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Oneways:"),
              (ReactDropDown()
                ..value = props.store.wayMode
                ..values = WayMode.values
                ..selectListener = ((newValue) => props.store.actions.wayModeChanged.call(newValue as WayMode))
              )()
          ) : null,
          props.store.directionMode != DirectionMode.ONLY_CARDINAL ?
          (Dom.div()..className = "config")(
              (Dom.div()..className = "title")("Cross Corners:"),
              (ReactDropDown()
                ..value = props.store.crossCornerMode
                ..values = CrossCornerMode.values
                ..selectListener = ((newValue) => props.store.actions.crossCornerModeChanged.call(newValue as CrossCornerMode))
              )()
          ) : null,
          (Dom.div()..className = "config")(
            (Dom.div()
              ..className = "button"
              ..onClick = ((_) => props.downloadGrid())
            )("download"),
          ),
          (Dom.div()..className = "config")(
            (Dom.label()
              ..className = "button"
              ..htmlFor = "upload"
            )("upload"),
            (Dom.input()
              ..id = "upload"
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
                  props.loadGrid(reader.result);
                }, onError: (dynamic error) => window.alert("Could not read Grid: ${reader.error.code}"));
                reader.readAsText(file);
                event.target.value = null;
              }
            )(),
          ),
        )
    );
  }
}