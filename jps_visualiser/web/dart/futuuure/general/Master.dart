import 'package:js/js.dart';

typedef Listener = void Function(MessageEvent event);

@anonymous
@JS()
abstract class MessageEvent {
  external dynamic get data;
}

@JS('postMessage')
external void postMessage(dynamic object);

@JS('onmessage')
external void set onMessage(dynamic function);

class Master
{
  void onMessage(Listener listener)
  {
    allowInterop(listener);
  }

  void postMessage(dynamic object)
  {
    postMessage(object);
  }
}