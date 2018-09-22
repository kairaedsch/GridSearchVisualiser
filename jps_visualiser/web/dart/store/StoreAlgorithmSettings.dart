import '../general/Save.dart';
import '../general/gui/DropDownElement.dart';
import '../model/algorithm/AStar.dart';
import '../model/algorithm/Algorithm.dart';
import '../model/algorithm/Dijkstra.dart';
import '../model/algorithm/JumpPointSearch.dart';
import '../model/algorithm/JumpPointSearchPlus.dart';
import '../model/algorithm/JumpPointSearchPlusDataGenerator.dart';
import '../model/heuristics/Chebyshev.dart';
import '../model/heuristics/Euclidean.dart';
import '../model/heuristics/Heuristic.dart';
import '../model/heuristics/Manhattan.dart';
import '../model/heuristics/Octile.dart';
import 'package:w_flux/w_flux.dart';

class StoreAlgorithmSettings extends Store
{
  ActionsAlgorithmSettingsChanged _actions;
  ActionsAlgorithmSettingsChanged get actions => _actions;

  AlgorithmType _algorithmType;
  AlgorithmType get algorithmType => _algorithmType;

  HeuristicType _heuristicType;
  HeuristicType get heuristicType => _heuristicType;

  StoreAlgorithmSettings()
  {
    _algorithmType = AlgorithmType.JPSP;
    _heuristicType = HeuristicType.OCTILE;

    _actions = new ActionsAlgorithmSettingsChanged();
    _actions.algorithmTypeChanged.listen(_algorithmTypeChanged);
    _actions.heuristicTypeChanged.listen(_heuristicTypeChanged);
  }

  void _algorithmTypeChanged(AlgorithmType newAlgorithmType)
  {
    _algorithmType = newAlgorithmType;
    trigger();
  }

  void _heuristicTypeChanged(HeuristicType newHeuristicType)
  {
    _heuristicType = newHeuristicType;
    trigger();
  }

  void save(Save save)
  {
    save.writeEnum(10, _algorithmType);
    save.writeEnum(11, _heuristicType);
  }

  void load(Save save)
  {
    _algorithmType = save.readEnum(10, AlgorithmType.values);
    _heuristicType = save.readEnum(11, HeuristicType.values);
    trigger();
  }
}

class ActionsAlgorithmSettingsChanged {
  final Action<AlgorithmType> algorithmTypeChanged = new Action<AlgorithmType>();
  final Action<HeuristicType> heuristicTypeChanged = new Action<HeuristicType>();
}

class AlgorithmType implements DropDownElement, SaveData<AlgorithmType>
{
  static AlgorithmType DIJKSTRA = new AlgorithmType(Dijkstra.factory, "DIJKSTRA", "Dijkstra");
  static AlgorithmType A_STAR = new AlgorithmType(AStar.factory, "A_STAR", "A*");
  static AlgorithmType JPS = new AlgorithmType(JumpPointSearch.factory, "JPS", "JPS");
  static AlgorithmType JPSP = new AlgorithmType(JumpPointSearchPlus.factory, "JPS+", "JPS+");
  static AlgorithmType JPSP_DATA = new AlgorithmType(JumpPointSearchPlusDataGenerator.factory, "JPS+ Data", "JPS+ Data");

  final String name;
  final String dropDownName;
  final AlgorithmFactory algorithmFactory;

  @override
  String toString() => name;

  const AlgorithmType(this.algorithmFactory, this.name, this.dropDownName);

  static List<AlgorithmType> values = <AlgorithmType>[
    DIJKSTRA, A_STAR, JPS, JPSP, JPSP_DATA];

  @override
  List<AlgorithmType> get saveDataValues => values;
}

class HeuristicType implements DropDownElement, SaveData<HeuristicType>
{
  static const HeuristicType MANHATTEN = const HeuristicType(const Manhattan(), "MANHATTEN", "Manhattan");
  static const HeuristicType EUCLIDEAN = const HeuristicType(const Euclidean(), "EUCLIDEAN", "Euclidean");
  static const HeuristicType OCTILE = const HeuristicType(const Octile(), "OCTILE", "Octile");
  static const HeuristicType CHEBYSHEV = const HeuristicType(const Chebyshev(), "CHEBYSHEV", "Chebyshev");

  final String name;
  final String dropDownName;
  final Heuristic heuristic;

  @override
  String toString() => name;

  const HeuristicType( this.heuristic, this.name, this.dropDownName);

  static const List<HeuristicType> values = const <HeuristicType>[
    MANHATTEN, EUCLIDEAN, OCTILE, CHEBYSHEV];

  @override
  List<HeuristicType> get saveDataValues => values;
}