import 'dart:async';
import 'dart:html';

class MouseTracker
{
  static MouseTracker _tracker = new MouseTracker();
  static MouseTracker get tracker => _tracker;

  bool _mouseIsDown = false;
  bool get mouseIsDown => _mouseIsDown;

  MouseTracker()
  {
    window.document.onMouseDown.listen((event) => this._mouseIsDown = true);
    window.document.onMouseUp.listen((event) => _mouseIsDown = false);
  }
}