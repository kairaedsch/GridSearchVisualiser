import 'futuuure/general/TransferMaster.dart';
import 'futuuure/pathfinder/PathfinderWorker.dart';
import 'futuuure/transfer/Data.dart';
import 'gui/ReactMain.dart';

void main()
{
  Data data = new Data();

  if (Data.useMultiThreading)
  {
    new TransferMaster('futuuure/pathfinder/PathfinderWorker.dart', data);
  }
  else
  {
    new PathfinderWorker.noIsolate(data);
  }

  initGUI(data);
}