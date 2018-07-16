import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import 'Highlight.dart';
import 'NodeSearchState.dart';
import 'package:quiver/core.dart';

class Explanation
{
  List<ExplanationPart> _explanation = [];
  List<ExplanationPart> get explanation => _explanation;

  void addT(String text)
  {
    _explanation.add(new ExplanationPart.Text(text));
  }

  void addH(String text, String style, List<Highlight> highlights)
  {
    _explanation.add(new ExplanationPart.Highlight(text, style, highlights));
  }
}

class ExplanationPart
{
  final String text;
  final List<Highlight> highlights;
  final Optional<String> style;

  ExplanationPart.Text(this.text)
      : highlights = [],
        style = const Optional.absent();

  ExplanationPart.Highlight(this.text, String style, this.highlights)
      : style = new Optional.of(style)
  {
    highlights.forEach((h) => h.setDefaultStyle(style));
  }
}