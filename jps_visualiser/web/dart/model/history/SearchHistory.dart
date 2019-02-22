import '../../general/geo/Position.dart';
import '../../general/geo/Size.dart';
import 'Explanation.dart';
import 'Highlight.dart';
import 'package:tuple/tuple.dart';

class SearchHistory
{
  int _id = 0;

  bool foundPath = false;
  String title = "";
  int stepCount = 0;
  String stepTitle = "";

  final List<Explanation> _stepDescription = [];
  List<Explanation> get stepDescription => _stepDescription;

  final Map<Position, Map<String, List<Highlight>>> _stepHighlights;
  Map<Position, Map<String, List<Highlight>>> get stepHighlights => _stepHighlights;

  SearchHistory(Size size)
    : _stepHighlights = new Map.fromIterable(size.positions(), value: (dynamic p) => new Map()..["background"] = [] ..["foreground"] = [])..[null] = (new Map()..["background"] = [] ..["foreground"] = []);

  void newExplanation(Explanation explanation)
  {
    _stepDescription.add(explanation);
  }

  void addES_(String text)
  {
    addEMM(text, "", [], []);
  }

  void addESS(String text, String style, Highlight highlight, Position position)
  {
    addEMM(text, style, [highlight], [position]);
  }

  void addEMS(String text, String style, Iterable<Highlight> highlights, Position position)
  {
    addEMM(text, style, highlights, [position]);
  }

  void addESM(String text, String style, Highlight highlight, Iterable<Position> positions)
  {
    addEMM(text, style, [highlight], positions);
  }

  void addEMM(String text, String style, Iterable<Highlight> highlights, Iterable<Position> positions)
  {
    addEM_(text, style, highlights.isNotEmpty ? [new Tuple2(highlights, positions)] : []);
  }

  void addEM_(String text, String style, List<Tuple2<Iterable<Highlight>, Iterable<Position>>> highlightsMap)
  {
    _stepDescription.last.explanation.add(new ExplanationPart(highlightsMap.isNotEmpty ? "${_id++}" : "foreground", text, style));
    appendHM(highlightsMap);
  }

  void appendH_(Iterable<Highlight> highlights, Iterable<Position> positions)
  {
    appendHM([new Tuple2(highlights, positions)]);
  }

  void appendHM(List<Tuple2<Iterable<Highlight>, Iterable<Position>>> highlightsMap)
  {
    var explanationPart = _stepDescription.last.explanation.last;
    highlightsMap.forEach((tuple) => tuple.item1.forEach((h) => h.setDefaultStyle(explanationPart.style)));
    addHM(explanationPart.id, highlightsMap);
  }

  void addH_(String id, Iterable<Highlight> highlights, Iterable<Position> positions)
  {
    addHM(id, [new Tuple2(highlights, positions)]);
  }

  void addHM(String id, Iterable<Tuple2<Iterable<Highlight>, Iterable<Position>>> highlightsMap)
  {
    highlightsMap.forEach((tuple) => tuple.item2.forEach((position) => _stepHighlights[position].putIfAbsent(id, () => new List()).addAll(tuple.item1)));
  }
}