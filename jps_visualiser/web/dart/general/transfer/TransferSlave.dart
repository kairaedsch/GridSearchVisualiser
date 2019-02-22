import 'dart:async';
import 'dart:html';

import '../general/Util.dart';
import 'StoreTransferAble.dart';
import 'Transfer.dart';

class TransferSlave extends Transfer
{
  DedicatedWorkerGlobalScope _slaveReceiver = DedicatedWorkerGlobalScope.instance;
  MessagePort _masterSender = null;

  TransferSlave(StoreTransferAble store) : super("Slave", store)
  {
    _slaveReceiver.onMessage.listen((MessageEvent message)
    {
      if (_masterSender == null)
      {
        Util.print('_masterSender is null and gets set');
        _masterSender = message.data as MessagePort;
      }
      else
      {
        receive(message.data as String);
      }
    });

    store.transferListener = (Iterable<String> ids)
    {
      if (_masterSender == null)
      {
        Util.print('_masterSender is null, transfer waiting to send for ids = $ids');
        new Timer(new Duration(milliseconds: 25), () => store.transferListener(ids));
      }
      else
      {
        return send(ids, (String message) => _masterSender.postMessage(message));
      }
    };
  }
}