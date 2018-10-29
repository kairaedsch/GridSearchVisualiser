import 'DataTransferAble.dart';
import 'dart:html';
import 'dart:convert';

class TransferMaster
{
  TransferMaster(DataTransferAble transfer, String webworker)
  {
    var worker = new Worker(webworker);

    worker.onMessage.listen((MessageEvent msg)
    {
      print('master: got  ${msg.data}');
      Map gar = JSON.decode(msg.data[0] as String) as Map<String, dynamic>;
      transfer.set(gar["id"] as String, gar["data"]);
    });

    transfer.addUniversalListener((String id, dynamic oldValue, dynamic newValue)
    {
      var data = new Map<String, dynamic>()..["id"] = id ..["data"] = transfer.getA<dynamic>(id);
      print('master: send $data');
      worker.postMessage(new JsData(data: JSON.encode(data)));
    });
  }
}