import 'Highlight.dart';

class Explanation
{
  final String style;

  List<ExplanationPart> _explanation = [];
  List<ExplanationPart> get explanation => _explanation;

  Explanation()
      : style = "";

  Explanation.styled(this.style);

  Explanation.fromMap(Map map)
      : style = map["style"] as String,
        _explanation = (map["explanation"] as List).map((dynamic map) => new ExplanationPart.fromMap(map as Map)).toList();

  Map toMap() => new Map<dynamic, dynamic>()
    ..["style"] = style
    ..["explanation"] = explanation.map((e) => e.toMap()).toList();
}

class ExplanationPart
{
  final String id;
  final String text;
  final String style;

  ExplanationPart(this.id, this.text, this.style);

  ExplanationPart.fromMap(Map map)
      : id = map["id"] as String,
        text = map["text"] as String,
        style = map["style"] as String;

  void setDefaultStyle(Iterable<Highlight> highlights)
  {
    highlights.forEach((h) => h.setDefaultStyle(style));
  }

  Map toMap() => new Map<dynamic, dynamic>()
    ..["id"] = id
    ..["text"] = text
    ..["style"] = style;
}