import '../../general/Position.dart';

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

  @override
  bool operator ==(dynamic o) => o is Highlight && o.style == style;
}

class BoxHighlight extends Highlight
{
  final Set<Position> positions;

  BoxHighlight(this.positions);

  BoxHighlight.styled(String style, this.positions)
  {
    this.style = style;
  }
}

class CircleHighlight extends Highlight
{
  final Set<Position> positions;

  CircleHighlight(this.positions);

  CircleHighlight.styled(String style, this.positions)
  {
    this.style = style;
  }
}

class DotHighlight extends Highlight
{
  final Set<Position> positions;

  DotHighlight(this.positions);

  DotHighlight.styled(String style, this.positions)
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

class InfoHighlight extends Highlight
{
  final Position position;
  final String info;

  InfoHighlight(this.info, this.position);

  InfoHighlight.styled(String style, this.info, this.position)
  {
    this.style = style;
  }
}