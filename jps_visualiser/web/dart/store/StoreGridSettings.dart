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

  CornerMode _cornerMode;
  CornerMode get cornerMode => _cornerMode;

  DirectionalMode _directionalMode;
  DirectionalMode get directionalMode => _directionalMode;

  StoreGridSettings()
  {
    _gridMode = GridMode.BASIC;
    _directionMode = DirectionMode.ALL;
    _cornerMode = CornerMode.CROSS;
    _directionalMode = DirectionalMode.MONO;

    _actions = new ActionsGridSettingsChanged();
    _actions.gridModeChanged.listen(_gridModeChanged);
    _actions.directionModeChanged.listen(_directionModeChanged);
    _actions.cornerModeChanged.listen(_cornerModeChanged);
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

  void _cornerModeChanged(CornerMode newCornerMode)
  {
    _cornerMode = newCornerMode;
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
    save.writeEnum(7, _cornerMode);
    save.writeEnum(8, _directionalMode);
  }

  void load(Save save)
  {
    _gridMode = save.readEnum(5, GridMode.values);
    _directionMode = save.readEnum(6, DirectionMode.values);
    _cornerMode = save.readEnum(7, CornerMode.values);
    _directionalMode = save.readEnum(8, DirectionalMode.values);
    trigger();
  }
}

class ActionsGridSettingsChanged
{
  final Action<GridMode> gridModeChanged = new Action<GridMode>();
  final Action<Size> sizeChanged = new Action<Size>();
  final Action<DirectionMode> directionModeChanged = new Action<DirectionMode>();
  final Action<CornerMode> cornerModeChanged = new Action<CornerMode>();
  final Action<DirectionalMode> directionalModeChanged = new Action<DirectionalMode>();
}

class GridMode implements DropDownElement, SaveData<GridMode>
{
  static const GridMode BASIC = const GridMode("BASIC", "Basic");
  static const GridMode ADVANCED = const GridMode("ADVANCED", "Advanced");

  static String popover = """
            <div class="title">Select the mode of the grid</div>
            <div class="options">
              <div class='title'>Basic</div>
              <div class='content'>
                Nodes can either be marked as walkable or as not walkable.
              </div>
              <div class='title'>Advanced</div>
              <div class='content'>
                For each direction a node can be marked as enterable or as not enterable.
              </div>
            </div>
            """;

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

  static String popover = """
            <div class="title">Select which directions are allowed</div>
            <div class="options">
              <div class='title'>All</div>
              <div class='content'>
                All 8 directions.
              </div>
              <div class='title'>Only cardinal</div>
              <div class='content'>
                Nort, east, south and west.
              </div>
              <div class='title'>Only diagonal</div>
              <div class='content'>
                Northeast, southeast, southwest and northwest.
              </div>
            </div>
            """;

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
  static const DirectionalMode MONO = const DirectionalMode("MONO", "Mono");
  static const DirectionalMode BI = const DirectionalMode("BI", "Bi");

  final String name;
  final String dropDownName;

  static String popover = """
            <div class="title">Select the directional mode</div>
            <div class="options">
              <div class='title'>Mono</div>
              <div class='content'>
                You can have one-way connections between nodes.
              </div>
              <div class='title'>Bi</div>
              <div class='content'>
                You can <strong>not</strong> have one-way connections between nodes.
              </div>
            </div>
            """;

  @override
  String toString() => name;

  const DirectionalMode(this.name, this.dropDownName);

  static const List<DirectionalMode> values = const <DirectionalMode>[MONO, BI];

  @override
  List<DirectionalMode> get saveDataValues => values;
}

class CornerMode implements DropDownElement, SaveData<CornerMode>
{
  static const CornerMode CROSS = const CornerMode("CROSS", "Cross");
  static const CornerMode BYPASS = const CornerMode("BYPASS", "Bypass");

  static String popover = """
            <div class="title">Select how corners are handled</div>
            <div class="options">
              <div class='title'>Cross</div>
              <div class='content'>
                Edges are allowed to cross blocked corners.
              </div>
              <div class='title'>Bypass</div>
              <div class='content'>
                Eges are not allowed to cross blocked corners.
              </div>
            </div>
            """;

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const CornerMode(this.name, this.dropDownName);

  static const List<CornerMode> values = const <CornerMode>[CROSS, BYPASS];

  @override
  List<CornerMode> get saveDataValues => values;
}