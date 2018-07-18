import 'Highlight.dart';
import 'package:quiver/core.dart';

class Explanation
{
  final Optional<String> style;

  List<ExplanationPart> _explanation = [];
  List<ExplanationPart> get explanation => _explanation;

  Explanation()
      : style = const Optional.absent();

  Explanation.styled(String style)
      : style = new Optional.of(style);

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