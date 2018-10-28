import '../../general/Position.dart';
import '../../futuuure/grid/Direction.dart';
import 'package:quiver/core.dart';

class Highlights
{
  static Highlight fromMap(Map map)
  {
    switch (map["highlight"] as String)
    {
      case "BoxHighlight": return new BoxHighlight.fromMap(map);
      case "CircleHighlight": return new CircleHighlight.fromMap(map);
      case "DotHighlight": return new DotHighlight.fromMap(map);
      case "PathHighlight": return new PathHighlight.fromMap(map);
      case "TextHighlight": return new TextHighlight.fromMap(map);
      case "DirectionTextHighlight": return new DirectionTextHighlight.fromMap(map);
    }
    throw new Exception("Invalid Highlight");
  }

  static Map toMapList(Map<String, List<Highlight>> highlights)
  {
    Map<String, List<Map>> mapList = new Map();
    highlights.forEach((key, list)
    {
      mapList[key] = list.map((h) => h.toMap()).toList();
    });
    return mapList;
  }

  static Map<String, List<Highlight>> fromMapList(Map<String, List<Map>> mapList)
  {
    Map<String, List<Highlight>> highlights = new Map();
    mapList.forEach((key, list)
    {
      highlights[key] = list.map((h) => fromMap(h)).toList();
    });
    return highlights;
  }
}

abstract class Highlight
{
  String style = "pleaseSetStyle";

  Highlight();

  Highlight.styled(String style)
  {
    this.style = style;
  }

  Highlight.fromMap(Map map)
      : style = map["style"] as String;

  Map toMap() => new Map<dynamic, dynamic>()
    ..["style"] = style;

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
  BoxHighlight();

  BoxHighlight.styled(String style) : super.styled(style);

  BoxHighlight.fromMap(Map map) : super.fromMap(map);

  Map toMap() => new Map<dynamic, dynamic>()
    ..["highlight"] = "BoxHighlight"
    ..["style"] = style;

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
  CircleHighlight();

  CircleHighlight.styled(String style) : super.styled(style);

  CircleHighlight.fromMap(Map map) : super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "CircleHighlight";

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
  DotHighlight();

  DotHighlight.styled(String style) : super.styled(style);

  DotHighlight.fromMap(Map map) : super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "DotHighlight";

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

  PathHighlight(this.path, {bool showStart, bool showEnd, Position origin})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false;

  PathHighlight.styled(String style, this.path, {bool showStart, bool showEnd, Position origin})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false,
        super.styled(style);

  PathHighlight.fromMap(Map map) :
        path = (map["path"] as List).map((Map map) => new Position.fromMap(map)).toList(),
        showEnd = map["showEnd"] as bool,
        showStart = map["showStart"] as bool,
        super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "PathHighlight"
    ..["path"] = path.map((p) => p.toMap()).toList()
    ..["showEnd"] = showEnd
    ..["showStart"] = showStart;

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
  final String text;

  TextHighlight(this.text);

  TextHighlight.styled(String style, this.text) : super.styled(style);

  TextHighlight.fromMap(Map map)
      : text = map["text"] as String,
        super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "TextHighlight"
    ..["text"] = text;

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
  final Direction direction;
  final String text;

  DirectionTextHighlight(this.text, this.direction);

  DirectionTextHighlight.styled(String style, this.text, this.direction) : super.styled(style);

  DirectionTextHighlight.fromMap(Map map)
      : direction = map["direction"] as Direction,
        text = map["text"] as String,
        super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "DirectionTextHighlight"
    ..["direction"] = direction
    ..["text"] = text;

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