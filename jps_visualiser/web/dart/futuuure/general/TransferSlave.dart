import 'Master.dart';
import 'Transfer.dart';

class TransferSlave
{
  TransferSlave(Transfer transfer)
  {
    Master master = new Master();

    master.onMessage((MessageEvent msg)
    {
      print('worker: got ${msg.data}');
      List<dynamic> command = msg.data as List<dynamic>;
      transfer.set(command[0].toString(), command[1]);
    });

    transfer.addListener((String id)
    {
      master.postMessage(<dynamic>[id, transfer.get<dynamic>(id)]);
    });
  }
}