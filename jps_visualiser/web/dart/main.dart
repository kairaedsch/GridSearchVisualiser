import 'dart:html';

import 'general/Size.dart';
import 'store/StoreMain.dart';
import 'package:over_react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart' as over_react;
import 'gui/ReactMain.dart';

void main() {
  // Initialize React
  over_react.setClientConfiguration();

  StoreMain storeMain = new StoreMain();
  react_dom.render(
      (ReactMain()
          ..store = storeMain
          ..actions = storeMain.actions
      )(),
      querySelector('#contentContainer')
  );
}