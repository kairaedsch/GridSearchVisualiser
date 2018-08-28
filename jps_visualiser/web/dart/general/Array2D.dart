import 'Position.dart';
import 'Size.dart';
import 'dart:core';

/// A generic 2D array with a width and a height.
class Array2D<T> extends Size
{
  /// The generic array.
  final List<List<T>> _array;

  /// Creates a new 2D array with the given size and producer function.
  Array2D(Size size, T producer(Position pos))
      : _array = new List<List<T>>.generate(size.width, (x) => new List<T>.generate(size.height, (y) => producer(new Position(x, y)))),
        super.clone(size);


  Iterable<T> get iterable => _array.expand((list) => list);

  /// Get the element at the given position.
  T operator [](Position pos) => _array[pos.x][pos.y];

  /// Set the given element at the given position.
  void operator []=(Position pos, T element) => _array[pos.x][pos.y] = element;
}