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
      Util.print('_slaveReceiver.onMessage: ${message.data}');
      if (_masterSender == null)
      {
        Util.print('_masterSender null');
        _masterSender = message.data as MessagePort;
      }
      else
      {
        Util.print('_masterSender not null: $_masterSender');
        receive(message.data);
      }
    });

    store.transferListener = (Iterable<String> ids) => send(ids, (message) => _masterSender.postMessage(message));
  }
}