
typedef Listener = void Function(String id);

class DataTransferAble
{
  final Map<String, dynamic> _data;
  final List<Listener> _listeners;

  DataTransferAble()
    :   _data = new Map<String, dynamic>(),
        _listeners = new List();

  T get<T>(String id) => _data[id] as T;

  void set(String id, dynamic newValue)
  {
    _data[id] = newValue;
    _listeners.forEach((listener) => listener(id));
  }

  void addListener(Listener listener)
  {
    _listeners.add(listener);
  }
}
