import '../../general/Bool.dart';
import '../../general/gui/DropDownElement.dart';
import 'package:w_flux/w_flux.dart';
import 'package:tuple/tuple.dart';

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
    _algorithmType = AlgorithmType.DIJKSTRA;
    _heuristicType = HeuristicType.MANHATTEN;

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
}

class ActionsAlgorithmSettingsChanged {
  final Action<AlgorithmType> algorithmTypeChanged = new Action<AlgorithmType>();
  final Action<HeuristicType> heuristicTypeChanged = new Action<HeuristicType>();
}

class AlgorithmType implements DropDownElement
{
  static const AlgorithmType DIJKSTRA = const AlgorithmType("DIJKSTRA", "Dijkstra");
  static const AlgorithmType A_STAR = const AlgorithmType("A_STAR", "A*");
  static const AlgorithmType JPS = const AlgorithmType("JPS", "JPS");

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const AlgorithmType(this.name, this.dropDownName);

  static const List<AlgorithmType> values = const <AlgorithmType>[
    DIJKSTRA, A_STAR, JPS];
}

class HeuristicType implements DropDownElement
{
  static const HeuristicType MANHATTEN = const HeuristicType("MANHATTEN", "Manhattan");
  static const HeuristicType EUCLIDEAN = const HeuristicType("EUCLIDEAN", "Euclidean");
  static const HeuristicType OCTILE = const HeuristicType("OCTILE", "Octile");
  static const HeuristicType CHEBYSHEV = const HeuristicType("CHEBYSHEV", "Chebyshev");

  final String name;
  final String dropDownName;

  @override
  String toString() => name;

  const HeuristicType(this.name, this.dropDownName);

  static const List<HeuristicType> values = const <HeuristicType>[
    MANHATTEN, EUCLIDEAN, OCTILE, CHEBYSHEV];
}