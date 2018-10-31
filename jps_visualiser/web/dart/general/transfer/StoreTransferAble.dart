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
  }

  void triggerListeners()
  {
    for (String changedId in changes)
    {
      if (_equalListeners.containsKey(changedId))
      {
        _equalListeners[changedId].forEach((equalListener) => equalListener());
      }
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
