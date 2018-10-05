import '../general/Save.dart';
import '../general/Size.dart';
import '../general/gui/DropDownElement.dart';
import 'package:w_flux/w_flux.dart';

class StoreGridSettings extends Store
{
  ActionsGridSettingsChanged _actions;
  ActionsGridSettingsChanged get actions => _actions;

  GridMode _gridMode;
  GridMode get gridMode => _gridMode;

  DirectionMode _directionMode;
  DirectionMode get directionMode => _directionMode;

  CrossCornerMode _crossCornerMode;
  CrossCornerMode get crossCornerMode => _crossCornerMode;

  DirectionalMode _directionalMode;
  DirectionalMode get directionalMode => _directionalMode;

  StoreGridSettings()
  {
    _gridMode = GridMode.BASIC;
    _directionMode = DirectionMode.ALL;
    _crossCornerMode = CrossCornerMode.ALLOW;
    _directionalMode = DirectionalMode.BI;

    _actions = new ActionsGridSettingsChanged();
    _actions.gridModeChanged.listen(_gridModeChanged);
    _actions.directionModeChanged.listen(_directionModeChanged);
    _actions.crossCornerModeChanged.listen(_crossCornerModeChanged);
    _actions.directionalModeChanged.listen(_directionalModeChanged);
  }

  void _gridModeChanged(GridMode newGridMode)
  {
    _gridMode = newGridMode;
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

  void _directionalModeChanged(DirectionalMode newDirectionalMode)
  {
    _directionalMode = newDirectionalMode;
    trigger();
  }

  void save(Save save)
  {
    save.writeEnum(5, _gridMode);
    save.writeEnum(6, _directionMode);
    save.writeEnum(7, _crossCornerMode);
    save.writeEnum(8, _directionalMode);
  }

  void load(Save save)
  {
    _gridMode = save.readEnum(5, GridMode.values);
    _directionMode = save.readEnum(6, DirectionMode.values);
    _crossCornerMode = save.readEnum(7, CrossCornerMode.values);
    _directionalMode = save.readEnum(8, DirectionalMode.values);
    trigger();
  }
}

class ActionsGridSettingsChanged
{
  final Action<GridMode> gridModeChanged = new Action<GridMode>();
  final Action<Size> sizeChanged = new Action<Size>();
  final Action<DirectionMode> directionModeChanged = new Action<DirectionMode>();
  final Action<CrossCornerMode> crossCornerModeChanged = new Action<CrossCornerMode>();
  final Action<DirectionalMode> directionalModeChanged = new Action<DirectionalMode>();
}

class GridMode implements DropDownElement, SaveData<GridMode>
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

  @override
  List<GridMode> get saveDataValues => values;
}

class DirectionMode implements DropDownElement, SaveData<DirectionMode>
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

  @override
  List<DirectionMode> get saveDataValues => values;
}

class DirectionalMode implements DropDownElement, SaveData<DirectionalMode>
{
  static const DirectionalMode MONO = const DirectionalMode("MONO_DIRECTIONAL", "mono");
  static const DirectionalMode BI = const DirectionalMode("BI_DIRECTIONAL", "bi");

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const DirectionalMode(this.name, this.dropDownName);

  static const List<DirectionalMode> values = const <DirectionalMode>[MONO, BI];

  @override
  List<DirectionalMode> get saveDataValues => values;
}

class CrossCornerMode implements DropDownElement, SaveData<CrossCornerMode>
{
  static const CrossCornerMode ALLOW = const CrossCornerMode("ALLOW", "Allow");
  static const CrossCornerMode DENY = const CrossCornerMode("DENY", "Deny");

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const CrossCornerMode(this.name, this.dropDownName);

  static const List<CrossCornerMode> values = const <CrossCornerMode>[ALLOW, DENY];

  @override
  List<CrossCornerMode> get saveDataValues => values;
}