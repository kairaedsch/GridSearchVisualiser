import '../general/general/Util.dart';
import '../model/store/Enums.dart';
import '../model/store/Store.dart';
import '../model/store/Save.dart';
import 'dart:html';
import 'package:over_react/over_react.dart';

import 'package:over_react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart' as over_react;

import 'grid/ReactGrid.dart';
import 'grid/arrows/ReactPaths.dart';
import 'settings/ReactGridSettings.dart';
import 'settings/ReactAlgorithmSettings.dart';
import 'history/ReactHistory.dart';
// ignore: uri_has_not_been_generated
part 'ReactMain.over_react.g.dart';

void initGUI(Store store)
{
  over_react.setClientConfiguration();

  setupAlgorithmRunner(store);
  setupArrowKeys(store);

  react_dom.render(
      (ReactMain()
        ..store = store
      )(),
      querySelector('#contentContainer')
  );
}

void setupAlgorithmRunner(Store store)
{
  window.document.onMouseUp.listen((event)
  {
    if (store.algorithmUpdateMode == AlgorithmUpdateMode.AFTER_EDITING)
    {
      store.triggerTransferListeners();
    }
  });
  var algorithmUpdateModeChanged = ()
  {
    if (store.algorithmUpdateMode == AlgorithmUpdateMode.AFTER_EDITING || store.algorithmUpdateMode == AlgorithmUpdateMode.MANUALLY)
    {
      store.autoTriggerTransferListener = false;
    }
    else
    {
      store.autoTriggerTransferListener = true;
    }
  };
  store.addEqualListener(["algorithmUpdateMode"], algorithmUpdateModeChanged);
  algorithmUpdateModeChanged();
  store.addEqualListener(["size", "algorithmType", "heuristicType", "gridMode", "directionMode", "cornerMode", "directionalMode", "currentStepId"], () => store.triggerTransferListeners());
}

void setupArrowKeys(Store store)
{
  window.document.onKeyDown.listen((event)
  {
    if (event.keyCode == KeyCode.RIGHT)
    {
      store.currentStepId = Util.range(store.currentStepId + 1, 0, store.stepCount - 1);
    }
    if (event.keyCode == KeyCode.LEFT)
    {
      store.currentStepId = Util.range(store.currentStepId - 1, 0, store.stepCount - 1);
    }
  });
}

@Factory()
UiFactory<ReactMainProps> ReactMain = _$ReactMain;

@Props()
class _$ReactMainProps extends UiProps
{
  Store store;
}

@Component()
class ReactMainComponent extends UiComponent<ReactMainProps>
{
  @override
  ReactElement render()
  {
    return (
    Dom.div()..className = "content")(
      (Dom.div()..className = "leftContent")(
        (ReactGrid()
          ..store = props.store
        )(),
        (ReactPaths()
          ..store = props.store
        )()
      ),
      (Dom.div()..className = "rightContent")(
        (Dom.div()..className = "gridSettingsContainer")(
            (ReactGridSettings()
              ..store = props.store
              ..download = _download
              ..load = _load
            )()
        ),
        (Dom.div()..className = "algorithmSettingsContainer")(
            (ReactAlgorithmSettings()
              ..store = props.store
            )()
        ),
        (Dom.div()..className = "historyContainer")(
            (ReactHistory()
              ..store = props.store
            )()
        )
      )
    );
  }

  void _download()
  {
    Save save = new Save(props.store);

    AnchorElement link = new AnchorElement();
    link.href = save.downloadLink();
    link.download = "grid.png";
    link.style.display = "false";
    querySelector('body').append(link);
    link.click();
  }

  void _load(String imageData)
  {
    new Save.loadFromSrc(imageData, props.store);
  }
}