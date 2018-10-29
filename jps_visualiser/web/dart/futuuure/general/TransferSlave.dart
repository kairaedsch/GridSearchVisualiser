import 'Slave.dart';
import 'DataTransferAble.dart';
import 'dart:convert';

class TransferSlave
{
  TransferSlave(DataTransferAble transfer)
  {
    Slave slave = new Slave();

    slave.onMessage((MessageEvent msg)
    {
      log('worker: got  ${msg.data}');
      Map gay = JSON.decode(msg.data[0] as String) as Map<String, dynamic>;
      transfer.set(gay["id"] as String, gay["data"]);
    });

    transfer.addUniversalListener((String id, dynamic oldValue, dynamic newValue)
    {
      var data = new Map<String, dynamic>()..["id"] = id ..["data"] = transfer.getA<dynamic>(id);
      log('worker: send $data');
      slave.postMessage(new JsData(data: JSON.encode(data)));
    });
  }
}