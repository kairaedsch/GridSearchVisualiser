import '../../general/gui/DropDownElement.dart';
import 'package:w_flux/w_flux.dart';
import 'package:tuple/tuple.dart';

class StoreConfig extends Store
{
  GridMode _gridMode;
  GridMode get gridMode => _gridMode;

  Tuple2<int, int> _size;
  Tuple2<int, int> get size => _size;

  ActionsConfigChanged _actions;
  ActionsConfigChanged get actions => _actions;

  StoreConfig()
  {
    _actions = new ActionsConfigChanged();
    _actions.gridModeChanged.listen(_gridModeChanged);
    _actions.sizeChanged.listen(_sizeChanged);
    _gridMode = GridMode.BASIC;
    _size = new Tuple2<int, int>(12, 12);
  }

  void _gridModeChanged(GridMode newGridMode)
  {
    _gridMode = newGridMode;
    trigger();
  }

  void _sizeChanged(Tuple2<int, int> newSize)
  {
    _size = newSize;
    trigger();
  }
}

class ActionsConfigChanged
{
  final Action<GridMode> gridModeChanged = new Action<GridMode>();
  final Action<Tuple2<int, int>> sizeChanged = new Action<Tuple2<int, int>>();
}

class GridMode implements DropDownElement
{
  static const GridMode BASIC = const GridMode("BASIC", "Basic");
  static const GridMode ADVANCED = const GridMode("ADVANCED", "Advanced");

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const GridMode(this.name, this.dropDownName);

  static const List<GridMode> values = const <GridMode>[
    BASIC, ADVANCED];
}