import 'Util.dart';

typedef SimpleListener = void Function();
typedef UniversalListener = void Function(List<String> ids);

class DataTransferAble
{
  final Map<String, dynamic> _data = new Map<String, dynamic>();
  final Map<SimpleListener, List<String>> _simpleListeners = new Map();
  final List<UniversalListener> _universalListeners = [];

  bool autoTriggerListeners = true;
  Map<String, bool> changes = new Map();

  T getA<T>(String id) => _data[id] as T;

  void set(String id, dynamic newValue, {bool triggerSyncing = true})
  {
    dynamic oldValue =  _data[id];
    if (triggerSyncing ? !Util.equal(newValue, oldValue) : (newValue != oldValue))
    {
      _data[id] = newValue;
      changes[id] = changes.containsKey(id) ? (changes[id] || triggerSyncing) : triggerSyncing;
      if (autoTriggerListeners)
      {
        triggerListeners();
      }
    }
  }

  void triggerListeners()
  {
    _simpleListeners.forEach((simpleListener, idStarts)
    {
      if (idStarts.any((idStart) => changes.keys.any((id) => id.startsWith(idStart))))
      {
        simpleListener();
      }
    });
    List<String> changesSyncable = changes.keys.where((id) => changes[id]).toList();
    if (changesSyncable.isNotEmpty)
    {
      _universalListeners.forEach((universalListener) => universalListener(changesSyncable));
    }
    changes.clear();
  }

  void addSimpleListener(List<String> idStarts, SimpleListener simpleListener)
  {
    _simpleListeners[simpleListener] = idStarts;
  }

  void removeSimpleListener(SimpleListener simpleListener)
  {
    _simpleListeners.remove(simpleListener);
  }

  void addUniversalListener(UniversalListener universalListener)
  {
    _universalListeners.add(universalListener);
  }
}
