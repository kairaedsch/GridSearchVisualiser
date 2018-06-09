import '../../general/Array2D.dart';
import '../../general/Position.dart';
import 'ExplanationNode.dart';
import 'StructureNode.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store
{
  Array2D<StructureNode> _structureNodes;
  Array2D<StructureNode> get structureNodes => _structureNodes;

  Array2D<ExplanationNode> _explanationNodes;
  Array2D<ExplanationNode> get explanationNodes => _explanationNodes;

  ActionsGridChanged _actions;

  StoreGrid(this._actions, int width, int height)
  {
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _structureNodes = new Array2D<StructureNode>(width, height, (Position pos) => new StructureNode.normal(pos));
    _explanationNodes = new Array2D<ExplanationNode>(width, height, (Position pos) => new ExplanationNode.normal(pos));
  }

  _changeStructureNode(StructureNode structureNode)
  {
    _structureNodes.set(structureNode.pos, structureNode);
    trigger();
  }

  _changeExplanationNode(ExplanationNode explanationNode)
  {
    _explanationNodes.set(explanationNode.pos, explanationNode);
    trigger();
  }
}

class ActionsGridChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
  final Action<ExplanationNode> explanationNodeChanged = new Action<ExplanationNode>();
}
