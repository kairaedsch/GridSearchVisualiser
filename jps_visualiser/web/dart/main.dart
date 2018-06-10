import 'dart:html';

import 'gui/store/StoreGrid.dart';
import 'package:over_react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart' as over_react;
import 'gui/nodes/ReactGrid.dart';

void main() {
  // Initialize React
  over_react.setClientConfiguration();

  var actions = new ActionsGridChanged();
  react_dom.render(
      (ReactGrid()
          ..store = new StoreGrid(actions, 32, 32)
          ..actions = actions
      )(),
      querySelector('#gridContainer')
  );
}