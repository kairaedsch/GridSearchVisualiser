import 'Position.dart';

class Size
{
  int _width;
  int get width => _width;

  int _height;
  int get height => _height;

  Size(this._width, this._height);

  Size.clone(Size size)
      : _width = size.width,
        _height = size.height;

  void resize(Size newSize)
  {
    _width = newSize.width;
    _height = newSize.height;
  }

  Iterable<Position> positions()
  {
    return new Iterable
        .generate(width, (x) => x)
        .expand((x) => new Iterable.generate(height, (y) => new Position(x, y)));
  }
}