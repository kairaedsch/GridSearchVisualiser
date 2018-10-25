import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/history/SearchHistory.dart';
import '../grid/Barrier.dart';
import '../general/DataTransferAble.dart';
import '../grid/GridBarrierManager.dart';
import 'GridSettings.dart';

class Data extends DataTransferAble
{
  static final bool useWebWorker = false;

  GridBarrierManager _gridBarrierManager;
  GridBarrierManager get gridBarrierManager => _gridBarrierManager;

  Data()
  {
    _gridBarrierManager = new GridBarrierManager(this);
  }

  AlgorithmType get algorithmType => get("algorithmType");
  void set algorithmType(AlgorithmType newValue) => set("algorithmType", newValue);

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

  int get currentStep => get("currentStep");
  void set currentStep(int newValue) => set("currentStep", newValue);

  Size get size => new Size(get("sizeWidth"), get("sizeHeight"));
  void set size(Size newValue)
  {
    set("sizeWidth", newValue.width);
    set("sizeHeight", newValue.height);
  }

  Barrier getBarrier(Position position) => get("barrier_$position");
  void setBarrier(Position position, Barrier newValue) => set("barrier_$position", newValue);

  Position get startPosition => new Position(get("startPositionX"), get("startPositionY"));
  void set startPosition(Position newValue)
  {
    set("startPositionX", newValue.x);
    set("startPositionY", newValue.y);
  }

  Position get targetPosition => new Position(get("targetPositionX"), get("targetPositionY"));
  void set targetPosition(Position newValue)
  {
    set("targetPositionX", newValue.x);
    set("targetPositionY", newValue.y);
  }

  SearchHistory get searchHistory => get("searchHistory");
  void set searchHistory(SearchHistory newValue) => set("searchHistory", newValue);
}