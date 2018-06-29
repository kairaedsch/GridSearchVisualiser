import '../store/StoreConfig.dart';
import '../../general/gui/ReactDropDown.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactMenuProps> ReactMenu;

@Props()
class ReactMenuProps extends UiProps
{
  StoreConfig storeConfig;
}

@Component()
class ReactMenuComponent extends UiComponent<ReactMenuProps>
{
  @override
  ReactElement render()
  {
    return (
        Dom.div()
          ..className = "menu"
    )(
      (Dom.div()..className = "config")(
          (Dom.div()..className = "title")("Gridmode"),
          (ReactDropDown()
            ..value = props.storeConfig.gridMode
            ..values = GridMode.values
            ..selectListener = ((newValue) => props.storeConfig.actions.gridModeChanged.call(newValue))
          )()
      ),
      (Dom.div()..className = "config")(
          (Dom.div()..className = "title")("Gridmode"),
          (ReactDropDown()
            ..value = props.storeConfig.gridMode
            ..values = GridMode.values
            ..selectListener = ((newValue) => props.storeConfig.actions.gridModeChanged.call(newValue))
          )()
      ),
    );
  }
}