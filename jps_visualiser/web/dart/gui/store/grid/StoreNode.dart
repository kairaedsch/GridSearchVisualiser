import '../../../general/Position.dart';
import '../../../model/history/NodeSearchState.dart';
import 'ExplanationNode.dart';
import '../StoreGridSettings.dart';
import 'StructureNode.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreNode extends Store
{
  final Position position;

  Optional<String> highlight;

  StructureNode _structureNode;
  StructureNode get structureNode => _structureNode;

  ExplanationNode _explanationNode;
  ExplanationNode get explanationNode => _explanationNode;

  ActionsNodeChanged _actions;
  ActionsNodeChanged get actions => _actions;

  StoreNode(this.position)
  {
    _structureNode = new StructureNode.normal();
    _explanationNode = const ExplanationNode.normal();
    highlight = const Optional.absent();

    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _actions.explanationNodeChanged.listen(_changeExplanationNode);
    _actions.highlightChanged.listen(_highlightChanged);

  }

  void _changeStructureNode(StructureNode structureNode)
  {
    _structureNode = structureNode;
    trigger();
  }

  void _changeExplanationNode(Optional<ExplanationNode> explanationNode)
  {
    _explanationNode = explanationNode.or(const ExplanationNode.normal());
    trigger();
  }

  void _highlightChanged(Optional<String> newHighlight)
  {
    highlight = newHighlight;
    trigger();
  }
}

class ActionsNodeChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
  final Action<Optional<ExplanationNode>> explanationNodeChanged = new Action<Optional<ExplanationNode>>();
  final Action<Optional<String>> highlightChanged = new Action<Optional<String>>();
}
