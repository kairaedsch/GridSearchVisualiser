import 'package:quiver/core.dart';

class ExplanationNode
{
  final Optional<String> marking;

  ExplanationNode(String marking) :
        marking = new Optional.of(marking);

  ExplanationNode.normal() :
        marking = const Optional.absent();
}