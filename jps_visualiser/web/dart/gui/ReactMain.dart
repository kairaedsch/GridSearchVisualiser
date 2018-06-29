import 'package:over_react/over_react.dart';
import 'store/StoreConfig.dart';
import 'store/StoreGrid.dart';
import 'nodes/ReactGrid.dart';
import 'menu/ReactMenu.dart';

@Factory()
UiFactory<ReactMainProps> ReactMain;

@Props()
class ReactMainProps extends FluxUiProps<ActionsConfigChanged, StoreConfig>
{
  StoreGrid storeGrid;
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
          ..storeConfig = props.store
          ..store = storeGrid
          ..actions = storeGrid.actions
        )()
      ),
      (Dom.div()..id = "rightContent")(
        (Dom.div()..className = "menuContainer")(
            (ReactMenu()
              ..storeConfig = props.store
            )()
        ),
        (Dom.div()..className = "stepsContainer")()
      )
    );
  }
}