import '../general/Bool.dart';
import '../general/Size.dart';
import '../general/gui/DropDownElement.dart';
import 'package:w_flux/w_flux.dart';
import 'package:tuple/tuple.dart';

class StoreGridSettings extends Store
{
  ActionsGridSettingsChanged _actions;
  ActionsGridSettingsChanged get actions => _actions;

  GridMode _gridMode;
  GridMode get gridMode => _gridMode;

  Size _size;
  Size get size => _size;

  DirectionMode _directionMode;
  DirectionMode get directionMode => _directionMode;

  CrossCornerMode _crossCornerMode;
  CrossCornerMode get crossCornerMode => _crossCornerMode;

  StoreGridSettings(Size size)
  {
    _size = size;
    _gridMode = GridMode.BASIC;
    _directionMode = DirectionMode.ALL;
    _crossCornerMode = CrossCornerMode.DENY;

    _actions = new ActionsGridSettingsChanged();
    _actions.gridModeChanged.listen(_gridModeChanged);
    _actions.sizeChanged.listen(_sizeChanged);
    _actions.directionModeChanged.listen(_directionModeChanged);
    _actions.crossCornerModeChanged.listen(_crossCornerModeChanged);
  }

  void _gridModeChanged(GridMode newGridMode)
  {
    _gridMode = newGridMode;
    trigger();
  }

  void _sizeChanged(Size newSize)
  {
    _size = newSize;
    trigger();
  }

  void _directionModeChanged(DirectionMode newDirectionMode)
  {
    _directionMode = newDirectionMode;
    trigger();
  }

  void _crossCornerModeChanged(CrossCornerMode newCrossCornerMode)
  {
    _crossCornerMode = newCrossCornerMode;
    trigger();
  }
}

class ActionsGridSettingsChanged
{
  final Action<GridMode> gridModeChanged = new Action<GridMode>();
  final Action<Size> sizeChanged = new Action<Size>();
  final Action<DirectionMode> directionModeChanged = new Action<DirectionMode>();
  final Action<CrossCornerMode> crossCornerModeChanged = new Action<CrossCornerMode>();
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

class DirectionMode implements DropDownElement
{
  static const DirectionMode ALL = const DirectionMode("ALL", "All");
  static const DirectionMode ONLY_CARDINAL = const DirectionMode("ONLY_CARDINAL", "Only cardinal");
  static const DirectionMode ONLY_DIAGONAL = const DirectionMode("ONLY_DIAGONAL", "Only diagonal");

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const DirectionMode(this.name, this.dropDownName);

  static const List<DirectionMode> values = const <DirectionMode>[ALL, ONLY_CARDINAL, ONLY_DIAGONAL];
}

class CrossCornerMode implements DropDownElement
{
  static const CrossCornerMode ALLOW = const CrossCornerMode("ALLOW", "Allow");
  static const CrossCornerMode DENY = const CrossCornerMode("DENY", "Deny");

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const CrossCornerMode(this.name, this.dropDownName);

  static const List<CrossCornerMode> values = const <CrossCornerMode>[ALLOW, DENY];
}