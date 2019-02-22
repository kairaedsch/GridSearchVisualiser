import 'dart:html';

import 'StoreTransferAble.dart';
import 'Transfer.dart';

class TransferMaster extends Transfer
{
  String _webworker;

  TransferMaster(this._webworker, StoreTransferAble store) : super("Master", store)
  {
    Worker worker = Worker("dart/$_webworker.js");
    MessageChannel msgChn = MessageChannel();
    worker.postMessage(msgChn.port1, [msgChn.port1]);
    msgChn.port2.onMessage.listen((MessageEvent message) => receive(message.data as String));

    store.transferListener = (Iterable<String> ids) => send(ids, (message) => worker.postMessage(message));
  }
}