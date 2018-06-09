import '../../general/Array2D.dart';
import '../../general/Position.dart';
import 'Node.dart';
import 'package:w_flux/w_flux.dart';

class StoreGrid extends Store
{
  Array2D<Node> _nodes;
  Array2D<Node> get nodes => _nodes;

  ActionsGridChanged _actions;

  StoreGrid(this._actions, int width, int height)
  {
    _actions.nodeChanged.listen(_changeNode);
    _nodes = new Array2D<Node>(width, height, (Position pos) => new Node.normal(pos));
  }

  _changeNode(Node node)
  {
    _nodes.set(node.pos, node);
    trigger();
  }
}

class ActionsGridChanged
{
  final Action<Node> nodeChanged = new Action<Node>();
}
