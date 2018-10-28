import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/history/Explanation.dart';
import '../../model/history/Highlight.dart';
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
    size = new Size(10, 10);
    size.positions().forEach((p) => setBarrier(p, Barrier.totalUnblocked));
    startPosition = new Position(0, 0);
    targetPosition = new Position(1, 1);

    algorithmType = AlgorithmType.JPSP;
    heuristicType = HeuristicType.OCTILE;
    gridMode = GridMode.BASIC;
    directionMode = DirectionMode.ALL;
    cornerMode = CornerMode.CROSS;
    directionalMode = DirectionalMode.MONO;

    title = "";
    stepCount = 0;
    currentStepId = -1;
    currentStepTitle = "";
    currentStepDescription = [];
    size.positions().forEach((p) => setCurrentStepHighlights(p, new Map()..["background"] = [] ..["foreground"] = []));
    setCurrentStepHighlights(null, new Map()..["background"] = [] ..["foreground"] = []);
  }

  // GRID #####################################################################
  Size get size => new Size.fromMap(getA("size"));
  void set size(Size newSize) => set("size", newSize.toMap());

  Barrier getBarrier(Position position) => new Barrier.fromMap(getA("barrier_$position"));
  void setBarrier(Position position, Barrier newBarrier) => set("barrier_$position", newBarrier.toMap());

  Position get startPosition => new Position.fromMap(getA("startPosition"));
  void set startPosition(Position newStartPosition) => set("startPosition", newStartPosition.toMap());

  Position get targetPosition => new Position.fromMap(getA("targetPosition"));
  void set targetPosition(Position newTargetPosition) => set("targetPosition", newTargetPosition.toMap());

  // ALGORITHM SETTINGS #######################################################
  AlgorithmType get algorithmType => getA("algorithmType");
  void set algorithmType(AlgorithmType newAlgorithmType) => set("algorithmType", newAlgorithmType);

  HeuristicType get heuristicType => getA("heuristicType");
  void set heuristicType(HeuristicType newHeuristicType) => set("heuristicType", newHeuristicType);

  // GRID SETTINGS ############################################################
  GridMode get gridMode => getA("gridMode");
  void set gridMode(GridMode newGridMode) => set("gridMode", newGridMode);

  DirectionMode get directionMode => getA("directionMode");
  void set directionMode(DirectionMode newDirectionMode) => set("directionMode", newDirectionMode);

  CornerMode get cornerMode => getA("cornerMode");
  void set cornerMode(CornerMode newCornerMode) => set("cornerMode", newCornerMode);

  DirectionalMode get directionalMode => getA("directionalMode");
  void set directionalMode(DirectionalMode newDirectionalMode) => set("directionalMode", newDirectionalMode);

  // HISTORY SETTINGS #########################################################
  String get title => getA("title");
  void set title(String newTitle) => set("title", newTitle);

  int get stepCount => getA("stepCount");
  void set stepCount(int newStepCount) => set("stepCount", newStepCount);

  int get currentStepId => getA("currentStepId");
  void set currentStepId(int newCurrentStep) => set("currentStepId", newCurrentStep);

  String get currentStepTitle => getA("currentStepTitle");
  void set currentStepTitle(String newTitle) => set("currentStepTitle", newTitle);

  List<Explanation> get currentStepDescription => (getA<List<Map>>("currentStepDescription")).map((map) => new Explanation.fromMap(map)).toList();
  void set currentStepDescription(List<Explanation> newExplanations) => set("currentStepDescription", newExplanations.map<Map>((Explanation p) => p.toMap()).toList());

  Map<String, List<Highlight>> getCurrentStepHighlights(Position position) => Highlights.fromMapList(getA("currentStepHighlights_$position"));
  void setCurrentStepHighlights(Position position, Map<String, List<Highlight>> newHighlights) => set("currentStepHighlights_$position", Highlights.toMapList(newHighlights));
}