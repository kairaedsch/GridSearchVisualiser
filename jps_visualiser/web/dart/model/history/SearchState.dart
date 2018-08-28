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

  int getTypeId()
  {
    return description.isEmpty ? 0 : description.map((e) => e.getTypeId()).reduce((t1, t2) => t1 ^ t2);
  }
}