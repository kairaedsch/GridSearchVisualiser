class Position
{
  final int x;
  final int y;

  const Position(this.x, this.y);

  get css => "pos_x_$x pos_y_$y";

  String toString() => "($x, $y)";
}