import 'package:over_react/over_react.dart';
import 'store/StoreConfig.dart';
import 'store/StoreGrid.dart';
import 'nodes/ReactGrid.dart';

@Factory()
UiFactory<ReactMainProps> ReactMain;

@Props()
class ReactMainProps extends FluxUiProps<ActionsConfigChanged, StoreConfig>
{
}

@Component()
class ReactMainComponent extends FluxUiComponent<ReactMainProps>
{
  @override
  render() {
    StoreGrid storeGrid = new StoreGrid(props.store.size.item1, props.store.size.item2);

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
        (Dom.div()..className = "menuContainer")(),
        (Dom.div()..className = "stepsContainer")()
      )
    );
  }
}