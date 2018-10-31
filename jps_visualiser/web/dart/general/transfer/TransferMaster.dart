import 'StoreTransferAble.dart';
import 'Transfer.dart';
import 'dart:async';
import 'dart:isolate';

class TransferMaster extends Transfer
{
  String _webworker;
  ReceivePort _masterReceiver;
  SendPort _slaveSender = null;

  TransferMaster(this._webworker, StoreTransferAble store) : super("Master", store)
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
      receive(jsonDatas);
    });

    store.transferListener = (Iterable<String> ids) => send(ids, _slaveSender);
  }

}