import 'DataTransferAble.dart';
import 'dart:html';

class TransferMaster
{
  TransferMaster(DataTransferAble transfer)
  {
    var worker = new Worker('worker/dog_raiser.dart.js');

    worker.onMessage.listen((MessageEvent msg)
    {
      print('master: got ${msg.data}');
      List<dynamic> command = msg.data as List<dynamic>;
      transfer.set(command[0].toString(), command[1]);
    });

    transfer.addUniversalListener((String id, dynamic oldValue, dynamic newValue)
    {
      worker.postMessage(<dynamic>[id, transfer.getA<dynamic>(id)]);
    });
  }
}