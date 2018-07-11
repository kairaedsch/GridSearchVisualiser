import '../../../general/Position.dart';
import '../../../model/NodeSearchState.dart';
import 'ExplanationNode.dart';
import '../StoreGridSettings.dart';
import 'StructureNode.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreNode extends Store
{
  final Position position;

  StructureNode _structureNode;
  StructureNode get structureNode => _structureNode;

  ExplanationNode _explanationNode;
  ExplanationNode get explanationNode => _explanationNode;

  ActionsNodeChanged _actions;
  ActionsNodeChanged get actions => _actions;

  StoreNode(this.position)
  {
    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _actions.explanationNodeChanged.listen(_changeExplanationNode);
    _structureNode = new StructureNode.normal();
    _explanationNode = const ExplanationNode.normal();
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
}

class ActionsNodeChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
  final Action<Optional<ExplanationNode>> explanationNodeChanged = new Action<Optional<ExplanationNode>>();
}
