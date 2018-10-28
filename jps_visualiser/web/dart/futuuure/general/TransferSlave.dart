import 'Master.dart';
import 'DataTransferAble.dart';

class TransferSlave
{
  TransferSlave(DataTransferAble transfer)
  {
    Master master = new Master();

    master.onMessage((MessageEvent msg)
    {
      print('worker: got ${msg.data}');
      List<dynamic> command = msg.data as List<dynamic>;
      transfer.set(command[0].toString(), command[1]);
    });

    transfer.addUniversalListener((String id, dynamic oldValue, dynamic newValue)
    {
      master.postMessage(<dynamic>[id, transfer.getA<dynamic>(id)]);
    });
  }
}