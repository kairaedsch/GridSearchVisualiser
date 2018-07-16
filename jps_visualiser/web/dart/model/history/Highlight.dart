import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import 'Explanation.dart';
import 'NodeSearchState.dart';
import 'package:quiver/core.dart';

abstract class Highlight
{
  String style = "pleaseSetStyle";

  void setDefaultStyle(String defaultStyle)
  {
    if (this.style == "pleaseSetStyle")
    {
      this.style = defaultStyle;
    }
  }
}

class PositionHighlight extends Highlight
{
  final Set<Position> positions;

  PositionHighlight(this.positions);

  PositionHighlight.styled(String style, this.positions)
  {
    this.style = style;
  }
}

class PathHighlight extends Highlight
{
  final List<Position> path;
  final bool showEnd;
  final bool showStart;

  PathHighlight(this.path, {bool showStart, bool showEnd})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false;

  PathHighlight.styled(String style, this.path, {bool showStart, bool showEnd})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false
  {
    this.style = style;
  }
}

class TextHighlight extends Highlight
{
  final Position position;
  final String text;

  TextHighlight(this.text, this.position);

  TextHighlight.styled(String style, this.text, this.position)
  {
    this.style = style;
  }
}