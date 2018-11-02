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
    var start = new DateTime.now();
    List<Map> datas = JSON.decode(jsonDatas as String) as List<Map<String, dynamic>>;
    store.autoTriggerListeners = false;
    for (Map data in datas)
    {
      store.set(data["id"] as String, data["data"], toTransfer: false);
    }
    store.autoTriggerListeners = true;
    store.triggerListeners();
    Util.print("$name: got  in ${new DateTime.now().difference(start).inMilliseconds}ms: ${datas.map((data) => data["id"] as String)}");
  }

  String send(Iterable<String> ids, SendPort sender)
  {
    var start = new DateTime.now();
    var data = ids.map((id) => new Map<String, dynamic>()..["id"] = id ..["data"] = store.getA<dynamic>(id)).toList();
    sender.send(JSON.encode(data));
    Util.print("$name: send in ${new DateTime.now().difference(start).inMilliseconds}ms: $ids");
  }
}