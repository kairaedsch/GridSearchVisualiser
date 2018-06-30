import 'dart:html';

import 'gui/store/StoreAlgorithmSettings.dart';
import 'gui/store/StoreGridSettings.dart';
import 'gui/store/StoreGrid.dart';
import 'package:over_react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart' as over_react;
import 'gui/ReactMain.dart';

void main() {
  // Initialize React
  over_react.setClientConfiguration();

  StoreGridSettings storeGridSettings = new StoreGridSettings();
  StoreAlgorithmSettings storeAlgorithmSettings = new StoreAlgorithmSettings();
  StoreGrid storeGrid = new StoreGrid(storeGridSettings);
  react_dom.render(
      (ReactMain()
          ..store = storeGridSettings
          ..actions = storeGridSettings.actions
          ..storeGrid = storeGrid
          ..storeAlgorithmSettings = storeAlgorithmSettings
      )(),
      querySelector('#contentContainer')
  );
}