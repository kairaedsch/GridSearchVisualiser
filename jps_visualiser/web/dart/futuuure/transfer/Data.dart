import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/history/Explanation.dart';
import '../../model/history/Highlight.dart';
import '../general/Util.dart';
import '../grid/Barrier.dart';
import '../general/DataTransferAble.dart';
import '../grid/GridBarrierManager.dart';
import 'GridSettings.dart';

class Data extends DataTransferAble
{
  static final bool useMultiThreading = true;

  GridBarrierManager _gridBarrierManager;
  GridBarrierManager get gridBarrierManager => _gridBarrierManager;

  Data()
  {
    _gridBarrierManager = new GridBarrierManager(this);
    size = new Size(20, 20);
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
    size.positions().forEach((p) => setCurrentStepHighlights(p, []));
    setCurrentStepHighlights(null, []);

    currentStepDescriptionHoverId = "foreground";
  }

  // GRID #####################################################################
  Size get size => new Size.fromMap(getA("size"));
  void set size(Size newSize) => set("size", newSize.toMap());

  Barrier getBarrier(Position position) => new Barrier.fromMap(Util.notNull(getA("barrier_$position"), orElse: () => Barrier.totalUnblocked.toMap()));
  void setBarrier(Position position, Barrier newBarrier) => set("barrier_$position", newBarrier.toMap());

  Position get startPosition => new Position.fromMap(getA("startPosition"));
  void set startPosition(Position newStartPosition) => set("startPosition", newStartPosition.toMap());

  Position get targetPosition => new Position.fromMap(getA("targetPosition"));
  void set targetPosition(Position newTargetPosition) => set("targetPosition", newTargetPosition.toMap());

  // ALGORITHM SETTINGS #######################################################
  AlgorithmType get algorithmType => AlgorithmType.values[getA<int>("algorithmType")];
  void set algorithmType(AlgorithmType newAlgorithmType) => set("algorithmType", newAlgorithmType.index);

  HeuristicType get heuristicType => HeuristicType.values[getA<int>("heuristicType")];
  void set heuristicType(HeuristicType newHeuristicType) => set("heuristicType", newHeuristicType.index);

  // GRID SETTINGS ############################################################
  GridMode get gridMode => GridMode.values[getA<int>("gridMode")];
  void set gridMode(GridMode newGridMode) => set("gridMode", newGridMode.index);

  DirectionMode get directionMode => DirectionMode.values[getA<int>("directionMode")];
  void set directionMode(DirectionMode newDirectionMode) => set("directionMode", newDirectionMode.index);

  CornerMode get cornerMode => CornerMode.values[getA<int>("cornerMode")];
  void set cornerMode(CornerMode newCornerMode) => set("cornerMode", newCornerMode.index);

  DirectionalMode get directionalMode => DirectionalMode.values[getA<int>("directionalMode")];
  void set directionalMode(DirectionalMode newDirectionalMode) => set("directionalMode", newDirectionalMode.index);

  // HISTORY SETTINGS #########################################################
  String get title => getA("title");
  void set title(String newTitle) => set("title", newTitle);

  int get stepCount => getA("stepCount");
  void set stepCount(int newStepCount) => set("stepCount", newStepCount);

  int get currentStepId => getA("currentStepId");
  void set currentStepId(int newCurrentStep) => set("currentStepId", newCurrentStep);

  String get currentStepDescriptionHoverId => getA("currentStepDescriptionHoverId");
  void set currentStepDescriptionHoverId(String newCurrentStepDescriptionHoverId) => set("currentStepDescriptionHoverId", newCurrentStepDescriptionHoverId);

  String get currentStepTitle => getA("currentStepTitle");
  void set currentStepTitle(String newTitle) => set("currentStepTitle", newTitle);

  List<Explanation> get currentStepDescription => (getA<List<Map>>("currentStepDescription")).map((map) => new Explanation.fromMap(map)).toList();
  void set currentStepDescription(List<Explanation> newExplanations) => set("currentStepDescription", newExplanations.map<Map>((Explanation p) => p.toMap()).toList());

  List<Highlight> getCurrentStepHighlights(Position position, String key) => Util.notNull(Highlights.fromListMap(getA("currentStepHighlights_$position")), orElse: () => []);
  void setCurrentStepHighlights(Position position, List<Highlight> newHighlights) => set("currentStepHighlights_$position", Highlights.toListMap(newHighlights));
}