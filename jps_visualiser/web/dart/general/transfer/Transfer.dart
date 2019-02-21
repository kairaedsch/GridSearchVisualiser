import '../general/Util.dart';
import 'StoreTransferAble.dart';
import 'dart:convert';

class Transfer
{
  String name;
  StoreTransferAble store;

  Transfer(this.name, this.store);

  void receive(dynamic jsonDatas)
  {
    Util.print("breforem conv. $jsonDatas");
    var start = new DateTime.now();
    Util.print("during conv. ${jsonDecode(jsonDatas)}");
    List<Map> datas = jsonDecode(jsonDatas);
    Util.print("after conv. $datas");
    store.autoTriggerListeners = false;
    for (Map data in datas)
    {
      store.set(data["id"], data["data"], toTransfer: false);
    }
    store.autoTriggerListeners = true;
    store.triggerListeners();
    Util.print("$name: got  in ${new DateTime.now().difference(start).inMilliseconds}ms: ${datas.map((data) => data["id"] as String)}");
  }

  String send(Iterable<String> ids, void postMessage(String))
  {
    var start = new DateTime.now();
    var data = ids.map((id) => new Map<String, dynamic>()..["id"] = id ..["data"] = store.getA<dynamic>(id)).toList();
    postMessage(jsonEncode(data));
    Util.print("$name: send in ${new DateTime.now().difference(start).inMilliseconds}ms: $ids");
  }
}