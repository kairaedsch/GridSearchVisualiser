import '../../futuuure/general/DataTransferAble.dart';
import '../../futuuure/transfer/Data.dart';
import '../../futuuure/transfer/GridSettings.dart';
import '../../general/gui/ReactDropDown.dart';
import '../../general/gui/ReactPopover.dart';
import 'dart:html';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactGridSettingsProps> ReactGridSettings;

@Props()
class ReactGridSettingsProps extends UiProps
{
  Data data;
  Function download;
  Function load;
  Function smallerGrid;
  Function biggerGrid;
}

@Component()
class ReactGridSettingsComponent extends UiComponent<ReactGridSettingsProps>
{
  Listener listener;

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = (String key, dynamic oldValue, dynamic newValue) => redraw();
    props.data.addListener(["gridMode", "directionMode", "cornerMode", "directionalMode"], listener);
  }

  @override
  ReactElement render()
  {
    return
      (Dom.div()..className = "menu")(
        (Dom.div()..className = "title")("Grid"),
        (Dom.div()..className = "configs")(
          (ReactPopover()
            ..className = "config"
            ..popover = GridModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Mode:"),
              (ReactDropDown()
                ..value = props.data.gridMode
                ..values = GridMode.values
                ..getTitle = GridModes.getTitle
                ..selectListener = ((dynamic newValue) => props.data.gridMode = newValue as GridMode)
              )()
          ),
          (ReactPopover()
            ..className = "config"
            ..popover = DirectionModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Directions:"),
              (ReactDropDown()
                ..value = props.data.directionMode
                ..values = DirectionMode.values
                ..getTitle = DirectionModes.getTitle
                ..selectListener = ((dynamic newValue) => props.data.directionMode = newValue as DirectionMode)
              )()
          ),
          props.data.gridMode != GridMode.BASIC ?
          (ReactPopover()
            ..className = "config"
            ..popover = DirectionalModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Directional:"),
              (ReactDropDown()
                ..value = props.data.directionalMode
                ..values = DirectionalMode.values
                ..getTitle = DirectionalModes.getTitle
                ..selectListener = ((dynamic newValue) => props.data.directionalMode = newValue as DirectionalMode)
              )()
          ) : null,
          props.data.directionMode != DirectionMode.ONLY_CARDINAL ?
          (ReactPopover()
            ..className = "config"
            ..popover = CornerModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Cross Corners:"),
              (ReactDropDown()
                ..value = props.data.cornerMode
                ..values = CornerMode.values
                ..getTitle = CornerModes.getTitle
                ..selectListener = ((dynamic newValue) => props.data.cornerMode = newValue as CornerMode)
              )()
          ) : null,
          (ReactPopover()
            ..className = "config icon"
            ..popover = "Shrink grid"
          )(
            (Dom.div()
              ..className = "button icon minus"
              ..onClick = ((_) => props.smallerGrid())
            )(" "),
          ),
          (ReactPopover()
            ..className = "config icon"
            ..popover = "Enlarge grid"
          )(
            (Dom.div()
              ..className = "button icon plus"
              ..onClick = ((_) => props.biggerGrid())
            )(" "),
          ),
          (ReactPopover()
            ..className = "config icon"
            ..popover = "Download grid"
          )(
            (Dom.div()
              ..className = "button icon save"
              ..onClick = ((_) => props.download())
            )(" "),
          ),
          (ReactPopover()
            ..className = "config icon"
            ..popover = "Load grid"
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

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.data.removeListener(listener);
  }
}