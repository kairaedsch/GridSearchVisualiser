import 'StoreTransferAble.dart';
import 'Transfer.dart';
import 'dart:isolate';

class TransferSlave extends Transfer
{
  ReceivePort _slaveReceiver;
  SendPort _masterSender;

  TransferSlave(this._masterSender, StoreTransferAble store) : super("Slave", store)
  {
    _slaveReceiver = new ReceivePort();
    _masterSender.send(_slaveReceiver.sendPort);

    _slaveReceiver.listen(receive);

    store.transferListener = (Iterable<String> ids) => send(ids, _masterSender);
  }
}