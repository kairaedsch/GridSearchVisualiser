import '../../general/Array2D.dart';
import '../../general/Direction.dart';
import '../../general/Position.dart';
import '../../general/Size.dart';
import '../../model/Grid.dart';
import '../StoreGridSettings.dart';
import '../grid/StoreNode.dart';
import '../grid/StructureNode.dart';
import '../history/StoreHistory.dart';
import 'StoreGrid.dart';
import 'package:w_flux/w_flux.dart';

typedef BarrierProvider = StructureNodeBarrier Function(Position position);

class GridBarrierManager
{
  final StoreGrid _storeGrid;
  final StoreGridSettings _storeGridSettings;
  final BarrierProvider _barrierProvider;

  GridBarrierManager(this._storeGrid, this._storeGridSettings, this._barrierProvider);

  StructureNodeBarrier getTotal(bool shouldBecomeBlocked)
  {
    return shouldBecomeBlocked ? StructureNodeBarrier.totalBlocked : StructureNodeBarrier.totalUnblocked;
  }

  Map<Position, StructureNodeBarrier> transformTo(Position position, Direction direction, bool shouldBecomeBlocked)
  {
    CornerMode cornerMode = _storeGridSettings.cornerMode;
    DirectionalMode directionalMode = _storeGridSettings.directionalMode;

    Map<Position, StructureNodeBarrier> transforms = new Map();

    transforms[position] = _barrierProvider(position).transformTo(direction, shouldBecomeBlocked);

    if (directionalMode == DirectionalMode.BI)
    {
      Position otherPosition = position.go(direction);
      if (otherPosition.legal(_storeGrid.size))
      {
        transforms[otherPosition] = _barrierProvider(otherPosition).transformTo(direction.turn(180), shouldBecomeBlocked);
      }
    }

    if (cornerMode == CornerMode.BYPASS && direction.isDiagonal)
    {
      Position positionPlus45 = position.go(direction.turn(45));
      if (positionPlus45.legal(_storeGrid.size))
      {
        transforms[positionPlus45] = _barrierProvider(positionPlus45).transformTo(direction.turn(-90), shouldBecomeBlocked);
      }
      Position positionMinus45 = position.go(direction.turn(-45));
      if (positionMinus45.legal(_storeGrid.size))
      {
        transforms[positionMinus45] = _barrierProvider(positionMinus45).transformTo(direction.turn(90), shouldBecomeBlocked);
      }
      Position positionPlus0 = position.go(direction.turn(0));
      if (positionPlus0.legal(_storeGrid.size))
      {
        transforms[positionPlus0] = _barrierProvider(positionPlus0).transformTo(direction.turn(180), shouldBecomeBlocked);
      }
    }

    return transforms;
  }

  bool somethingToDisplay(Position position)
  {
    DirectionMode directionMode = _storeGridSettings.directionMode;

    List<Direction> interestingDirections;
    if (directionMode == DirectionMode.ONLY_CARDINAL)
    {
      interestingDirections = Direction.cardinals;
    }
    else if (directionMode == DirectionMode.ONLY_DIAGONAL)
    {
      interestingDirections = Direction.diagonals;
    }
    else
    {
      interestingDirections = Direction.values;
    }

      return interestingDirections.every((direction) => enterAble(position, direction));
  }

  Grid toGrid()
  {
    return new Grid(_storeGrid.size, (Position pos) => new Node(pos, (direction) => leaveAble(pos, direction)));
  }

  bool leaveAndEnterAble(Position position, Direction direction)
  {
    return leaveAble(position, direction) && enterAble(position, direction);
  }

  bool enterAbleInAnyDirection(Position position)
  {
    return Direction.values.any((direction) => enterAble(position, direction));
  }

  bool enterAble(Position position, Direction direction)
  {
    return leaveAble(position.go(direction), direction.turn(180));
  }

  bool leaveAble(Position position, Direction direction)
  {
    GridMode gridMode = _storeGridSettings.gridMode;
    DirectionMode directionMode = _storeGridSettings.directionMode;
    CornerMode cornerMode = _storeGridSettings.cornerMode;
    DirectionalMode directionalMode = _storeGridSettings.directionalMode;

    if (!position.legal(_storeGrid.size))
    {
      return false;
    }

    bool isDirectlyBlocked;
    if (gridMode == GridMode.BASIC)
    {
      isDirectlyBlocked = _leaveBlockedDirectly(position, direction) || _enterBlockedDirectly(position, direction);
    }
    else
    {
      isDirectlyBlocked = _leaveBlockedDirectly(position, direction);
    }

    if (isDirectlyBlocked)
    {
      return false;
    }

    if (directionMode == DirectionMode.ONLY_CARDINAL)
    {
      if (direction.isDiagonal)
      {
        return false;
      }
    }
    else if (directionMode == DirectionMode.ONLY_DIAGONAL)
    {
      if (direction.isCardinal)
      {
        return false;
      }
    }

    if (directionalMode == DirectionalMode.BI)
    {
      if (_enterBlockedDirectly(position, direction))
      {
        return false;
      }
    }

    if (direction.isDiagonal && cornerMode == CornerMode.BYPASS)
    {
      bool isCornerBlocked = _enterBlockedDirectly(position, direction)
          || _leaveBlockedDirectly(position.go(direction.turn(45)), direction.turn(-90))
          || _enterBlockedDirectly(position.go(direction.turn(45)), direction.turn(-90));

      if (isCornerBlocked)
      {
        return false;
      }
    }

    return true;
  }

  bool _leaveBlockedDirectly(Position position, Direction direction)
  {
    GridMode gridMode = _storeGridSettings.gridMode;
    Position targetPosition = position.go(direction);
    return !targetPosition.legal(_storeGrid.size)
        || !position.legal(_storeGrid.size)
        || (gridMode == GridMode.BASIC ? _barrierProvider(targetPosition).isAnyBlocked() : _barrierProvider(targetPosition).isBlocked(direction.turn(180)));
  }

  bool _enterBlockedDirectly(Position position, Direction direction)
  {
    GridMode gridMode = _storeGridSettings.gridMode;
    Position startPosition = position.go(direction);
    return !startPosition.legal(_storeGrid.size)
        || !position.legal(_storeGrid.size)
        || (gridMode == GridMode.BASIC ? _barrierProvider(position).isAnyBlocked() : _barrierProvider(position).isBlocked(direction));
  }
}
