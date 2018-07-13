import '../../general/Array2D.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
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

  void addN(String text, List<Position> nodes, String type)
  {
    _explanation.add(new ExplanationPart.Node(text, nodes, type));
  }
}

class ExplanationPart
{
  final String text;
  final List<Position> nodes;
  final Optional<String> type;

  ExplanationPart.Text(this.text)
      : nodes = [],
        type = const Optional.absent();

  ExplanationPart.Node(this.text, this.nodes, String type)
      : type = new Optional.of(type);
}