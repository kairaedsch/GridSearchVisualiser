import 'dart:html';

import 'gui/store/StoreConfig.dart';
import 'package:over_react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart' as over_react;
import 'gui/ReactMain.dart';

void main() {
  // Initialize React
  over_react.setClientConfiguration();

  StoreConfig storeConfig = new StoreConfig();
  react_dom.render(
      (ReactMain()
          ..store = storeConfig
          ..actions = storeConfig.actions
      )(),
      querySelector('#contentContainer')
  );
}