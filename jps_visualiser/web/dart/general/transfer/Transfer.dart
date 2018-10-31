import '../general/Util.dart';
import 'StoreTransferAble.dart';
import 'dart:convert';
import 'dart:isolate';

class Transfer
{
  String name;
  StoreTransferAble store;

  Transfer(this.name, this.store);

  void receive(dynamic jsonDatas)
  {
    List<Map> datas = JSON.decode(jsonDatas as String) as List<Map<String, dynamic>>;
    Util.print('$name: got  ${datas.map((data) => data["id"] as String)}');
    store.autoTriggerListeners = false;
    for (Map data in datas)
    {
      store.set(data["id"] as String, data["data"], toTransfer: false);
    }
    store.autoTriggerListeners = true;
    store.triggerListeners();
  }

  String send(Iterable<String> ids, SendPort sender)
  {
    var data = ids.map((id) => new Map<String, dynamic>()..["id"] = id ..["data"] = store.getA<dynamic>(id)).toList();
    Util.print('$name: send $ids');
    sender.send(JSON.encode(data));
  }
}