import '../../general/Position.dart';
import '../../futuuure/grid/Direction.dart';
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

class BoxHighlight extends Highlight
{
  final Set<Position> positions;

  BoxHighlight(this.positions);

  BoxHighlight.styled(String style, this.positions)
  {
    this.style = style;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BoxHighlight &&
              runtimeType == other.runtimeType &&
              style == other.style;

  @override
  int get hashCode =>
      style.hashCode;
}

class CircleHighlight extends Highlight
{
  final Set<Position> positions;

  CircleHighlight(this.positions);

  CircleHighlight.styled(String style, this.positions)
  {
    this.style = style;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CircleHighlight &&
              runtimeType == other.runtimeType &&
              style == other.style;

  @override
  int get hashCode =>
      style.hashCode;
}

class DotHighlight extends Highlight
{
  final Set<Position> positions;

  DotHighlight(this.positions);

  DotHighlight.styled(String style, this.positions)
  {
    this.style = style;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DotHighlight &&
              runtimeType == other.runtimeType &&
              style == other.style;

  @override
  int get hashCode =>
      style.hashCode;
}

class PathHighlight extends Highlight
{
  final List<Position> path;
  final bool showEnd;
  final bool showStart;
  final Optional<Position> origin;

  PathHighlight(this.path, {bool showStart, bool showEnd, Position origin})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false,
        origin = origin != null ? new Optional.of(origin) : const Optional.absent();

  PathHighlight.styled(String style, this.path, {bool showStart, bool showEnd, Position origin})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false,
        origin = origin != null ? new Optional.of(origin) : const Optional.absent()
  {
    this.style = style;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PathHighlight &&
              runtimeType == other.runtimeType &&
              style == other.style &&
              path == other.path &&
              showEnd == other.showEnd &&
              showStart == other.showStart;

  @override
  int get hashCode =>
      style.hashCode ^
      path.hashCode ^
      showEnd.hashCode ^
      showStart.hashCode;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TextHighlight &&
              runtimeType == other.runtimeType &&
              style == other.style &&
              text == other.text;

  @override
  int get hashCode =>
      style.hashCode ^
      text.hashCode;
}

class DirectionTextHighlight extends Highlight
{
  final Position position;
  final Direction direction;
  final String text;

  DirectionTextHighlight(this.text, this.position, this.direction);

  DirectionTextHighlight.styled(String style, this.text, this.position, this.direction)
  {
    this.style = style;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DirectionTextHighlight &&
              runtimeType == other.runtimeType &&
              style == other.style &&
              direction == other.direction &&
              text == other.text;

  @override
  int get hashCode =>
      style.hashCode ^
      direction.hashCode ^
      text.hashCode;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is InfoHighlight &&
              runtimeType == other.runtimeType &&
              style == other.style &&
              info == other.info;

  @override
  int get hashCode =>
      style.hashCode ^
      info.hashCode;
}