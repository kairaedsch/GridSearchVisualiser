import '../../general/Array2D.dart';
import '../../general/Position.dart';
import 'ExplanationNode.dart';
import 'StructureNode.dart';
import 'package:w_flux/w_flux.dart';

class StoreNode extends Store
{
  StructureNode _structureNode;
  StructureNode get structureNode => _structureNode;

  ExplanationNode _explanationNode;
  ExplanationNode get explanationNode => _explanationNode;

  ActionsNodeChanged _actions;
  ActionsNodeChanged get actions => _actions;

  StoreNode(Position pos)
  {
    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _structureNode = new StructureNode.normal(pos);
    _explanationNode = new ExplanationNode.normal(pos);
  }

  _changeStructureNode(StructureNode structureNode)
  {
    _structureNode = structureNode;
    trigger();
  }

  _changeExplanationNode(ExplanationNode explanationNode)
  {
    _explanationNode = explanationNode;
    trigger();
  }
}

class ActionsNodeChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
  final Action<ExplanationNode> explanationNodeChanged = new Action<ExplanationNode>();
}
