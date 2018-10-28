import '../futuuure/transfer/Data.dart';
import '../general/Save.dart';
import 'dart:html';
import 'package:over_react/over_react.dart';

import 'package:over_react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart' as over_react;

import 'nodes/ReactGrid.dart';
import 'nodes/arrows/ReactPaths.dart';
import 'menu/ReactGridSettings.dart';
import 'menu/ReactAlgorithmSettings.dart';
import 'history/ReactHistory.dart';

void initGUI(Data data)
{
  over_react.setClientConfiguration();

  react_dom.render(
      (ReactMain()
        ..data = data
      )(),
      querySelector('#contentContainer')
  );
}

@Factory()
UiFactory<ReactMainProps> ReactMain;

@Props()
class ReactMainProps extends UiProps
{
  Data data;
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
          ..data = props.data
        )(),
        (ReactPaths()
          ..data = props.data
        )()
      ),
      (Dom.div()..className = "rightContent")(
        (Dom.div()..className = "gridSettingsContainer")(
            (ReactGridSettings()
              ..data = props.data
              ..download = _download
              ..load = _load
            )()
        ),
        (Dom.div()..className = "algorithmSettingsContainer")(
            (ReactAlgorithmSettings()
              ..data = props.data
            )()
        ),
        (Dom.div()..className = "historyContainer")(
            (ReactHistory()
              ..data = props.data
            )()
        )
      )
    );
  }

  void _download()
  {
    Save save = new Save(props.data);

    AnchorElement link = new AnchorElement();
    link.href = save.downloadLink();
    link.download = "grid.png";
    link.style.display = "false";
    querySelector('body').append(link);
    link.click();
  }

  void _load(String imageData)
  {
    new Save.load(imageData, props.data);
  }
}