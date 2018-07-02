import '../../general/Bool.dart';
import '../../general/gui/DropDownElement.dart';
import 'package:w_flux/w_flux.dart';
import 'package:tuple/tuple.dart';

class StoreGridSettings extends Store
{
  ActionsGridSettingsChanged _actions;
  ActionsGridSettingsChanged get actions => _actions;

  GridMode _gridMode;
  GridMode get gridMode => _gridMode;

  Tuple2<int, int> _size;
  Tuple2<int, int> get size => _size;

  Bool _allowDiagonal;
  Bool get allowDiagonal => _allowDiagonal;

  Bool _crossCorners;
  Bool get crossCorners => _crossCorners;

  StoreGridSettings()
  {
    _gridMode = GridMode.BASIC;
    _size = new Tuple2<int, int>(16, 15);
    _allowDiagonal = Bool.TRUE;
    _crossCorners = Bool.TRUE;

    _actions = new ActionsGridSettingsChanged();
    _actions.gridModeChanged.listen(_gridModeChanged);
    _actions.sizeChanged.listen(_sizeChanged);
    _actions.allowDiagonalChanged.listen(_allowDiagonalChanged);
    _actions.crossCornersChanged.listen(_crossCornersChanged);
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

  void _allowDiagonalChanged(Bool newAllowDiagonal)
  {
    _allowDiagonal = newAllowDiagonal;
    trigger();
  }

  void _crossCornersChanged(Bool newCrossCorners)
  {
    _crossCorners = newCrossCorners;
    trigger();
  }
}

class ActionsGridSettingsChanged
{
  final Action<GridMode> gridModeChanged = new Action<GridMode>();
  final Action<Tuple2<int, int>> sizeChanged = new Action<Tuple2<int, int>>();
  final Action<Bool> allowDiagonalChanged = new Action<Bool>();
  final Action<Bool> crossCornersChanged = new Action<Bool>();
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