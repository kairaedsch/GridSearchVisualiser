import '../../general/geo/Position.dart';
import '../../general/geo/Direction.dart';

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

  static List<Map> toListMap(List<Highlight> highlights)
  {
    return highlights.map((h) => h.toMap()).toList();
  }

  static List<Highlight> fromListMap(List<Map> mapList)
  {
    return mapList.map((map) => fromMap(map)).toList();
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
}

class CircleHighlight extends Highlight
{
  CircleHighlight();

  CircleHighlight.styled(String style) : super.styled(style);

  CircleHighlight.fromMap(Map map) : super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "CircleHighlight";
}

class DotHighlight extends Highlight
{
  DotHighlight();

  DotHighlight.styled(String style) : super.styled(style);

  DotHighlight.fromMap(Map map) : super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "DotHighlight";
}

class PathHighlight extends Highlight
{
  final List<Position> path;
  final bool showEnd;
  final bool showStart;
  final double startIntermediate;
  final double endIntermediate;

  PathHighlight(this.path, {bool showStart, bool showEnd, double startIntermediate, double endIntermediate, Position origin})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false,
        startIntermediate = startIntermediate != null ? startIntermediate : 1.0,
        endIntermediate = endIntermediate != null ? endIntermediate : 1.0;

  PathHighlight.styled(String style, this.path, {bool showStart, bool showEnd, double startIntermediate, double endIntermediate, Position origin})
      : showEnd = showEnd != null ? showEnd : false,
        showStart = showStart != null ? showStart : false,
        startIntermediate = startIntermediate != null ? startIntermediate : 1.0,
        endIntermediate = endIntermediate != null ? endIntermediate : 1.0,
        super.styled(style);

  PathHighlight.fromMap(Map map) :
        path = (map["path"] as List).map((dynamic map) => new Position.fromMap(map as Map)).toList(),
        showEnd = map["showEnd"] as bool,
        showStart = map["showStart"] as bool,
        startIntermediate = map["startIntermediate"] as double,
        endIntermediate = map["endIntermediate"] as double,
        super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "PathHighlight"
    ..["path"] = path.map((p) => p.toMap()).toList()
    ..["showEnd"] = showEnd
    ..["showStart"] = showStart
    ..["startIntermediate"] = startIntermediate
    ..["endIntermediate"] = endIntermediate;
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
}

class DirectionTextHighlight extends Highlight
{
  final Direction direction;
  final String text;

  DirectionTextHighlight(this.text, this.direction);

  DirectionTextHighlight.styled(String style, this.text, this.direction) : super.styled(style);

  DirectionTextHighlight.fromMap(Map map)
      : direction = Direction.values[map["direction"] as int],
        text = map["text"] as String,
        super.fromMap(map);

  Map toMap() => super.toMap()
    ..["highlight"] = "DirectionTextHighlight"
    ..["direction"] = direction.index
    ..["text"] = text;
}