import '../../general/Array2D.dart';
import '../../general/Position.dart';
import 'StoreNode.dart';
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
    _storeNodes = new Array2D<StoreNode>(width, height, (Position pos) => new StoreNode(pos));
  }
}

class ActionsGridChanged
{

}
