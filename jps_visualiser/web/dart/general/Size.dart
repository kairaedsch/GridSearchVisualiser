import 'Position.dart';

class Size
{
  final int _width;
  int get width => _width;

  final int _height;
  int get height => _height;

  Size(this._width, this._height);

  Size.clone(Size size)
      : _width = size.width,
        _height = size.height;

  Iterable<Position> positions()
  {
    return new Iterable
        .generate(width, (x) => x)
        .expand((x) => new Iterable.generate(height, (y) => new Position(x, y)));
  }
}