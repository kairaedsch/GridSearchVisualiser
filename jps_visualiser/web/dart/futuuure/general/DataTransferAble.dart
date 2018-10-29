import 'package:js/js.dart';

typedef Listener = void Function(String id, dynamic oldValue, dynamic newValue);

@anonymous
@JS()
abstract class JsData
{
  external dynamic get data;

  external factory JsData({String data});
}

class DataTransferAble
{
  final Map<String, dynamic> _data;
  final Map<Object, Listener> _listeners;

  DataTransferAble()
    :   _data = new Map<String, dynamic>(),
        _listeners = new Map();

  T getA<T>(String id) => _data[id] as T;

  void set(String id, dynamic newValue)
  {
    dynamic oldValue =  _data[id];
    _data[id] = newValue;
    _listeners.values.forEach((listener) => listener(id, oldValue, newValue));
  }

  void removeListener(Listener listener)
  {
    _listeners.remove(listener);
  }

  void addListener(List<String> keys, Listener listener)
  {
    _listeners[listener] = ((key, dynamic oldValue, dynamic newValue) {
      if (keys.any((k) => key.startsWith(k))) listener(key, oldValue, newValue);
    });
  }

  void addUniversalListener(Listener listener)
  {
    addListener([""], listener);
  }
}
