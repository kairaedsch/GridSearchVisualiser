import 'Settings.dart';
import 'general/transfer/TransferMaster.dart';
import 'model/PathfinderWorker.dart';
import 'model/store/Store.dart';
import 'gui/ReactMain.dart';

void main()
{
  Store store = new Store();

  if (Settings.useMultiThreading)
  {
    new TransferMaster('model/PathfinderWorker.dart', store);
  }
  else
  {
    new PathfinderWorker.noIsolate(store);
  }

  initGUI(store);
}