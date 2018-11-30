import 'dart:html';

class MouseTracker
{
  static MouseTracker _tracker = new MouseTracker();
  static MouseTracker get tracker => _tracker;

  bool _mouseIsDown = false;
  bool get mouseIsDown => _mouseIsDown;
  DateTime lastMouseEvent;

  MouseTracker()
  {
    lastMouseEvent = new DateTime.now();
    window.document.onMouseDown.listen((event)
    {
      this._mouseIsDown = true;
      lastMouseEvent = new DateTime.now();
    });
    window.document.onMouseUp.listen((event)
    {
      _mouseIsDown = false;
      lastMouseEvent = new DateTime.now();
    });
  }
}