import '../../general/Array2D.dart';
import '../../general/Position.dart';
import 'ExplanationNode.dart';
import 'StoreNode.dart';
import 'StructureNode.dart';
import 'package:w_flux/w_flux.dart';
import 'package:tuple/tuple.dart';

class StoreGrid extends Store
{
  Array2D<StoreNode> _storeNodes;
  Array2D<StoreNode> get storeNodes => _storeNodes;

  ActionsGridChanged _actions;
  ActionsGridChanged get actions => _actions;

  StoreGrid(int width, int height)
  {
    _actions = new ActionsGridChanged();
    _actions.sizeChanged.listen(__sizeChanged);
    _storeNodes = new Array2D<StoreNode>(width, height, (Position pos) => new StoreNode(pos));
  }

  __sizeChanged(Tuple2<int, int> newSize)
  {
    trigger();
  }
}

class ActionsGridChanged
{
  final Action<Tuple2<int, int>> sizeChanged = new Action<Tuple2<int, int>>();
}
