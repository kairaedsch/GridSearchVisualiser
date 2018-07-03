import '../../../general/Position.dart';
import '../../../model/NodeSearchState.dart';
import 'ExplanationNode.dart';
import '../StoreGridSettings.dart';
import 'StructureNode.dart';
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

  StoreNode(StoreGridSettings storeGridSettings, this.position)
  {
    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _actions.explanationNodeChanged.listen(_changeExplanationNode);
    storeGridSettings.actions.gridModeChanged.listen(_changeGridMode);
    _structureNode = new StructureNode.normal();
    _explanationNode = new ExplanationNode.normal();
  }

  void _changeStructureNode(StructureNode structureNode)
  {
    _structureNode = structureNode;
    trigger();
  }

  void _changeExplanationNode(NodeSearchState nodeSearchState)
  {
    _explanationNode = new ExplanationNode(nodeSearchState.nodeMarking.name);
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
  final Action<NodeSearchState> explanationNodeChanged = new Action<NodeSearchState>();
}
