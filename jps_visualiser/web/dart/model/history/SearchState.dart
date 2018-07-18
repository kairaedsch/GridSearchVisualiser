import 'Explanation.dart';
import 'Highlight.dart';

class SearchState
{
  final int turn;

  Explanation title = new Explanation();
  List<Explanation> description = [];
  List<Highlight> backgroundHighlights = [];
  List<Highlight> defaultHighlights = [];

  SearchState(this.turn);
}