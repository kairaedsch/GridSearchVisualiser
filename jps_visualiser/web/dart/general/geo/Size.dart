import 'Position.dart';

class Size
{
  final int width;

  final int height;

  Size(this.width, this.height);

  Size.clone(Size size)
      : width = size.width,
        height = size.height;

  Size.fromMap(Map map)
      : width = map["width"] as int,
        height = map["height"] as int;

  Map toMap() => new Map<dynamic, dynamic>()
    ..["width"] = width
    ..["height"] = height;

  Iterable<Position> positions()
  {
    return new Iterable
        .generate(width, (x) => x)
        .expand((x) => new Iterable.generate(height, (y) => new Position(x, y)));
  }
}