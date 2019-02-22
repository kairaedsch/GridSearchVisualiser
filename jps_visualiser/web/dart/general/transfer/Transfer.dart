import '../general/Util.dart';
import 'StoreTransferAble.dart';
import 'dart:convert';

class Transfer
{
  String name;
  StoreTransferAble store;

  Transfer(this.name, this.store);

  void receive(String jsonDatas)
  {
    var start = new DateTime.now();
    List<Map> datas = (jsonDecode(jsonDatas) as Iterable<dynamic>).map((dynamic map) => map as Map).toList();
    store.autoTriggerListeners = false;
    for (Map data in datas)
    {
      store.set(data["id"] as String, data["data"], toTransfer: false);
    }
    store.autoTriggerListeners = true;
    store.triggerListeners();
    Util.print("$name: got   in ${new DateTime.now().difference(start).inMilliseconds}ms: ${datas.map((data) => data["id"] as String)}");
  }

  String send(Iterable<String> ids, void postMessage(String message))
  {
    var start = new DateTime.now();
    var data = ids.map((id) => new Map<String, dynamic>()..["id"] = id ..["data"] = store.getA<dynamic>(id)).toList();
    postMessage(jsonEncode(data));
    Util.print("$name: send out ${new DateTime.now().difference(start).inMilliseconds}ms: $ids");
  }
}