import '../general/Util.dart';

typedef EqualListener = void Function();
typedef StartsWithListener = void Function(Iterable<String> ids);
typedef TransferListener = void Function(Iterable<String> ids);

class StoreTransferAble
{
  final Map<String, dynamic> _store = new Map<String, dynamic>();
  final Map<String, List<EqualListener>> _equalListeners = new Map();
  final Map<StartsWithListener, List<String>> _startsWithListener = new Map();
  TransferListener transferListener = (ids) => null;

  bool autoTriggerListeners = true;
  bool autoTriggerTransferListener = true;
  Set<String> changes = new Set();
  Set<String> changesToTransfer = new Set();

  T getA<T>(String id) => _store[id] as T;

  List<Map> getAListMap(String id) => (_store[id] as Iterable).map((dynamic map) => map as Map).toList();

  void set(String id, dynamic newValue, {bool toTransfer = true})
  {
    if (newValue == null)
    {
      return;
    }
    dynamic oldValue =  _store[id];
    if (toTransfer ? !Util.equal(newValue, oldValue) : (newValue != oldValue))
    {
      _store[id] = newValue;

      addChange(id, toTransfer);
    }
  }

  void addChange(String id, bool toTransfer)
  {
    changes.add(id);
    if (toTransfer)
    {
      changesToTransfer.add(id);
    }

    if (autoTriggerListeners)
    {
      triggerListeners();
    }
  }

  void triggerListeners()
  {
    Set<EqualListener> equalListenerCalled = new Set();
    for (String changedId in changes)
    {
      var changedIdStart = new DateTime.now();
      _equalListeners[changedId]?.where((el) => !equalListenerCalled.contains(el))?.forEach((equalListener)
      {
        equalListener();
        equalListenerCalled.add(equalListener);
      });
      var changedIdFinish = new DateTime.now();
      // Util.print("triggerLis: changedId $changedId ${changedIdFinish.difference(changedIdStart).inMilliseconds}ms (${_equalListeners[changedId]?.length})");
    }

    _startsWithListener.forEach((startsWithListener, startsOfIds)
    {
      var matchingIds = changes.where((changedId) => startsOfIds.any((startOfId) => changedId.startsWith(startOfId))).toList();
      if (matchingIds.isNotEmpty)
      {
        startsWithListener(matchingIds);
      }
    });

    changes.clear();

    if (autoTriggerTransferListener)
    {
      triggerTransferListeners();
    }
  }

  void triggerTransferListeners()
  {
    if (changesToTransfer.isNotEmpty)
    {
      transferListener(changesToTransfer);
    }
    changesToTransfer.clear();
  }

  void addEqualListener(List<String> ids, EqualListener equalListener)
  {
    for (String id in ids)
    {
      _equalListeners.putIfAbsent(id, () => []).add(equalListener);
    }
  }

  void removeEqualListener(EqualListener equalListener)
  {
    _equalListeners.forEach((id, list) => list.remove(equalListener));
  }

  void addStartsWithListener(List<String> startsOfIds, StartsWithListener startsWithListener)
  {
    _startsWithListener[startsWithListener] = startsOfIds;
  }

  void removeStartsWithListener(StartsWithListener startsWithListener)
  {
    _startsWithListener.forEach((idStart, list) => list.remove(startsWithListener));
  }
}
