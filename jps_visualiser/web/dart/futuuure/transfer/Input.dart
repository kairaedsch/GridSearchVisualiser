import '../general/Transfer.dart';
import 'GridSettings.dart';

class Input extends Transfer
{
  AlgorithmType get algorithmType => get("AlgorithmType");
  void set algorithmType(AlgorithmType newValue) => set("AlgorithmType", newValue);

  HeuristicType get heuristicType => get("heuristicType");
  void set heuristicType(HeuristicType newValue) => set("heuristicType", newValue);

  GridMode get gridMode => get("gridMode");
  void set gridMode(GridMode newValue) => set("gridMode", newValue);

  DirectionMode get directionMode => get("directionMode");
  void set directionMode(DirectionMode newValue) => set("directionMode", newValue);

  CornerMode get cornerMode => get("cornerMode");
  void set cornerMode(CornerMode newValue) => set("cornerMode", newValue);

  DirectionalMode get directionalMode => get("directionalMode");
  void set directionalMode(DirectionalMode newValue) => set("directionalMode", newValue);
}