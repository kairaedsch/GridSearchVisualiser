import 'Position.dart';
import 'Size.dart';
import 'dart:core';

typedef Producer<T> = T Function(Position pos);

/// A generic 2D array with a width and a height.
class Array2D<T> extends Size
{
  /// The generic array.
  List<List<T>> _array;

  final Producer<T> _producer;

  /// Creates a new 2D array with the given size and producer function.
  Array2D(Size size, this._producer) : super.clone(size)
  {
    _array = new List<List<T>>.generate(size.width, (x) => new List<T>.generate(size.height, (y) => _producer(new Position(x, y))));
  }

  bool contains(Position position)
  {
    return _array.length > position.x && _array[position.x].length > position.y;
  }

  Iterable<T> get iterable => _array.expand((list) => list);

  /// Get the element at the given position.
  T operator [](Position pos) => _array[pos.x][pos.y];

  /// Set the given element at the given position.
  void operator []=(Position pos, T element) => _array[pos.x][pos.y] = element;
}