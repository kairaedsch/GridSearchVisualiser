import 'Settings.dart';
import 'dart:async';
import 'general/gui/MouseTracker.dart';
import 'general/transfer/TransferMaster.dart';
import 'model/PathfinderWorker.dart';
import 'model/store/Save.dart';
import 'model/store/Store.dart';
import 'gui/ReactMain.dart';

void main()
{
  Store store = new Store();

  if (Settings.useMultiThreading)
  {
    try
    {
      new TransferMaster('model/PathfinderWorker.dart', store);
    }
    catch (ex)
    {
      new PathfinderWorker.noIsolate(store);
    }
  }
  else
  {
    new PathfinderWorker.noIsolate(store);
  }
  new Save.loadFromCookie(store);

  initGUI(store);

  DateTime lastSave = new DateTime.now();
  new Timer.periodic(new Duration(milliseconds: 1000), (t)
  {
    if (MouseTracker.tracker.lastMouseEvent.isAfter(lastSave))
    {
      if (!MouseTracker.tracker.mouseIsDown)
      {
        Save save = new Save(store);
        save.saveToCookie();
        lastSave = new DateTime.now();
      }
    }
  });
}