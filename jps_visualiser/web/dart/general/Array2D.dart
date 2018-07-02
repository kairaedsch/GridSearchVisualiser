import 'Position.dart';
import 'Size.dart';
import 'dart:core';

/// A generic 2D array with a width and a height.
class Array2D<T> implements Size
{
  /// The generic array.
  final List<List<T>> _array;

  /// The width of our array.
  final int width;

  /// The height of our array.
  final int height;

  /// Creates a new 2D array with the given size and producer function.
  Array2D(this.width, this.height, T producer(Position pos))
      : _array = new List<List<T>>.generate(width, (x) => new List<T>.generate(height, (y) => producer(new Position(x, y))));

  Iterable<T> get iterable => _array.expand((list) => list);

  /// Get the element at the given position.
  T operator [](Position pos) => _array[pos.x][pos.y];

  /// Set the given element at the given position.
  void operator []=(Position pos, T element) => _array[pos.x][pos.y] = element;
}