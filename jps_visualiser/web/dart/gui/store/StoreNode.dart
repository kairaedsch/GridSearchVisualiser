import '../../general/Position.dart';
import 'ExplanationNode.dart';
import 'StoreGridSettings.dart';
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

  StoreNode(StoreGridSettings storeGridSettings, Position pos)
  {
    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _actions.explanationNodeChanged.listen(_changeExplanationNode);
    storeGridSettings.actions.gridModeChanged.listen(_changeGridMode);
    _structureNode = new StructureNode.normal(pos);
    _explanationNode = new ExplanationNode.normal(pos);
  }

  void _changeStructureNode(StructureNode structureNode)
  {
    _structureNode = structureNode;
    trigger();
  }

  void _changeExplanationNode(ExplanationNode explanationNode)
  {
    _explanationNode = explanationNode;
    trigger();
  }

  void _changeGridMode(GridMode newGridMode) {
    if (structureNode.barrier.isAnyBlocked())
    {
      trigger();
    }
  }
}

class ActionsNodeChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
  final Action<ExplanationNode> explanationNodeChanged = new Action<ExplanationNode>();
}
