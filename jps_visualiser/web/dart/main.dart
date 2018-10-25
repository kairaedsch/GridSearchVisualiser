import 'futuuure/general/TransferMaster.dart';
import 'futuuure/pathfinder/PathfinderWorker.dart';
import 'futuuure/transfer/Data.dart';
import 'gui/ReactMain.dart';

void main()
{
  Data data = new Data();

  if (Data.useWebWorker)
  {
    new TransferMaster(data);
  }
  else
  {
    new PathfinderWorker(data);
  }

  initGUI(data);
}