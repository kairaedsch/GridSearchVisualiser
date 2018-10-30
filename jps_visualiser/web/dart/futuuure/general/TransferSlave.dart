import 'DataTransferAble.dart';
import 'dart:convert';
import 'dart:isolate';

class TransferSlave
{
  DataTransferAble _transfer;
  ReceivePort _slaveReceiver;
  SendPort _masterSender;

  TransferSlave(this._masterSender, this._transfer)
  {
    _slaveReceiver = new ReceivePort();
    _masterSender.send(_slaveReceiver.sendPort);

    _slaveReceiver.listen((dynamic jsonDatas)
    {
      List<Map> datas = JSON.decode(jsonDatas as String) as List<Map<String, dynamic>>;
      print('worker: got  ${datas.map((data) => data["id"] as String)}');
      for (Map data in datas)
      {
        _transfer.autoTriggerListeners = false;
        _transfer.set(data["id"] as String, data["data"], triggerSyncing: false);
        _transfer.autoTriggerListeners = true;
        _transfer.triggerListeners();
      }
    });

    _transfer.addUniversalListener((List<String> ids)
    {
      var data = ids.map((id) => new Map<String, dynamic>()..["id"] = id ..["data"] = _transfer.getA<dynamic>(id)).toList();
      print('worker: send $ids');
      _masterSender.send(JSON.encode(data));
    });
  }
}