import 'DataTransferAble.dart';
import 'Util.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

class TransferMaster
{
  String _webworker;
  DataTransferAble _transfer;
  ReceivePort _masterReceiver;
  SendPort _slaveSender = null;

  TransferMaster(this._webworker, this._transfer)
  {
    _masterReceiver = new ReceivePort();
    Future<Isolate> future = Isolate.spawnUri(Uri.parse(identical(1, 1.0) ? "dart/$_webworker.js" : _webworker), [], _masterReceiver.sendPort);
    future.then(_setup);
  }

  Future<Null> _setup(Isolate isolate) async
  {
    _masterReceiver.listen((dynamic jsonDatas)
    {
      if (_slaveSender == null)
      {
        _slaveSender = jsonDatas as SendPort;
        return;
      }
      List<Map> datas = JSON.decode(jsonDatas as String) as List<Map<String, dynamic>>;
      Util.print('master: got  ${datas.map((data) => data["id"] as String)}');
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
      Util.print('master: send $ids');
      _slaveSender.send(JSON.encode(data));
    });
  }

}