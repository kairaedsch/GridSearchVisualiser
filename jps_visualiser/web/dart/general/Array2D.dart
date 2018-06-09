import 'Position.dart';
import 'dart:core';

/// A generic 2D array with a width and a height.
class Array2D<T>
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

  /// Get the element at the given position.
  T get(Position pos) => _array[pos.x][pos.y];

  /// Set the given element at the given position.
  void set(Position pos, T element) => _array[pos.x][pos.y] = element;
}