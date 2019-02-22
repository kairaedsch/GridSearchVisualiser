import '../../general/transfer/StoreTransferAble.dart';
import '../../model/store/Store.dart';
import '../../model/store/Enums.dart';
import '../../general/geo/Size.dart';
import '../../general/gui/ReactDropDown.dart';
import '../../general/gui/ReactPopover.dart';
import 'dart:html';
import 'package:over_react/over_react.dart';
// ignore: uri_has_not_been_generated
part 'ReactGridSettings.over_react.g.dart';

@Factory()
UiFactory<ReactGridSettingsProps> ReactGridSettings = _$ReactGridSettings;

@Props()
class _$ReactGridSettingsProps extends UiProps
{
  Store store;
  Function download;
  Function load;
}

@Component()
class ReactGridSettingsComponent extends UiComponent<ReactGridSettingsProps>
{
  EqualListener listener;

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = () => redraw();
    props.store.addEqualListener(["gridMode", "directionMode", "cornerMode", "directionalMode"], listener);
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
                ..value = props.store.gridMode
                ..values = GridMode.values
                ..getTitle = ((dynamic e) => GridModes.getTitle(e as GridMode))
                ..selectListener = ((dynamic newValue) => props.store.gridMode = newValue as GridMode)
              )()
          ),
          (ReactPopover()
            ..className = "config"
            ..popover = DirectionModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Directions:"),
              (ReactDropDown()
                ..value = props.store.directionMode
                ..values = DirectionMode.values
                ..getTitle = ((dynamic e) => DirectionModes.getTitle(e as DirectionMode))
                ..selectListener = ((dynamic newValue) => props.store.directionMode = newValue as DirectionMode)
              )()
          ),
          props.store.gridMode != GridMode.BASIC ?
          (ReactPopover()
            ..className = "config"
            ..popover = DirectionalModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Directional:"),
              (ReactDropDown()
                ..value = props.store.directionalMode
                ..values = DirectionalMode.values
                ..getTitle = ((dynamic e) => DirectionalModes.getTitle(e as DirectionalMode))
                ..selectListener = ((dynamic newValue) => props.store.directionalMode = newValue as DirectionalMode)
              )()
          ) : null,
          props.store.directionMode != DirectionMode.ONLY_CARDINAL ?
          (ReactPopover()
            ..className = "config"
            ..popover = CornerModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Cross Corners:"),
              (ReactDropDown()
                ..value = props.store.cornerMode
                ..values = CornerMode.values
                ..getTitle = ((dynamic e) => CornerModes.getTitle(e as CornerMode))
                ..selectListener = ((dynamic newValue) => props.store.cornerMode = newValue as CornerMode)
              )()
          ) : null,
          (ReactPopover()
            ..className = "config small"
            ..popover = "Shrink grid"
          )(
            (Dom.div()
              ..className = "button icon minus"
              ..onClick = ((_) => props.store.gridManager.setSize(new Size(props.store.size.width - 1, props.store.size.height - 1)))
            )(" "),
          ),
          (ReactPopover()
            ..className = "config small"
            ..popover = "Enlarge grid"
          )(
            (Dom.div()
              ..className = "button icon plus"
              ..onClick = ((_) => props.store.gridManager.setSize(new Size(props.store.size.width + 1, props.store.size.height + 1)))
            )(" "),
          ),
          (ReactPopover()
            ..className = "config small"
            ..popover = "Download grid"
          )(
            (Dom.div()
              ..className = "button icon save"
              ..onClick = ((_) => props.download())
            )(" "),
          ),
          (ReactPopover()
            ..className = "config small"
            ..popover = "Load grid"
          )(
            (Dom.label()
              ..className = "button icon load"
              ..htmlFor = "load"
            )(" "),
            (Dom.input()
              ..id = "load"
              ..type = "file"
              ..accept="image/png"
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
                }, onError: (dynamic error) => window.alert("Could not read Grid: ${reader.error.hashCode}"));
                reader.readAsDataUrl(file);
                event.target.value = null;
              }
            )(),
          ),
          (ReactPopover()
            ..className = "config small"
            ..popover = "Clear grid"
          )(
            (Dom.div()
              ..className = "button icon clear"
              ..onClick = ((_) => props.store.gridManager.clear())
            )(" "),
          ),
        )
    );
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.store.removeEqualListener(listener);
  }
}