import 'dart:async';
import 'package:js/js.dart';

typedef Listener = void Function(MessageEvent event);

@anonymous
@JS()
abstract class MessageEvent
{
  external dynamic get data;
}

@JS('postMessage')
external void postMessageNative(dynamic object);

@JS('onmessage')
external void set onMessageNative(dynamic function);

class Slave
{
  void onMessage(Listener listener)
  {
    onMessageNative = allowInterop((dynamic event)
    {
      log('worker got ${event}');
      listener(event as MessageEvent);
    });
  }

  void postMessage(dynamic object)
  {
    postMessageNative(object);
  }
}

void log(String msg)
{
  print(msg);
  new Timer(const Duration(milliseconds: 1), ()
  {
    throw new UnsupportedError(msg);
  });
}