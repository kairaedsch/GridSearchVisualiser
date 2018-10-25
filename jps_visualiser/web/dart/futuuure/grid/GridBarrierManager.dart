import '../../futuuure/transfer/Data.dart';
import '../../futuuure/transfer/GridSettings.dart';
import '../../general/Position.dart';
import 'Barrier.dart';
import 'Direction.dart';

class GridBarrierManager
{
  final Data _data;

  GridBarrierManager(this._data);

  void setTotal(Position position, bool shouldBecomeBlocked)
  {
    Barrier barrier = shouldBecomeBlocked ? Barrier.totalBlocked : Barrier.totalUnblocked;
    _data.setBarrier(position, barrier);
  }

  void _setDirect(Position position, Direction direction, bool shouldBecomeBlocked)
  {
    _data.setBarrier(position, _data.getBarrier(position)..set(direction, shouldBecomeBlocked));
  }

  void set(Position position, Direction direction, bool shouldBecomeBlocked)
  {
    CornerMode cornerMode = _data.cornerMode;
    DirectionalMode directionalMode = _data.directionalMode;

    _setDirect(position, direction, shouldBecomeBlocked);

    if (directionalMode == DirectionalMode.BI)
    {
      Position otherPosition = position.go(direction);
      if (otherPosition.legal(_data.size))
      {
        _setDirect(otherPosition, Directions.turn(direction, 180), shouldBecomeBlocked);
      }
    }

    if (cornerMode == CornerMode.BYPASS && Directions.isDiagonal(direction))
    {
      Position positionPlus45 = position.go(Directions.turn(direction, 45));
      if (positionPlus45.legal(_data.size))
      {
        _setDirect(positionPlus45, Directions.turn(direction, -90), shouldBecomeBlocked);
      }
      Position positionMinus45 = position.go(Directions.turn(direction, -45));
      if (positionMinus45.legal(_data.size))
      {
        _setDirect(positionMinus45, Directions.turn(direction, 90), shouldBecomeBlocked);
      }
      Position positionPlus0 = position.go(Directions.turn(direction, 0));
      if (positionPlus0.legal(_data.size))
      {
        _setDirect(positionPlus0, Directions.turn(direction, 180), shouldBecomeBlocked);
      }
    }
  }

  bool somethingToDisplay(Position position)
  {
    DirectionMode directionMode = _data.directionMode;

    List<Direction> interestingDirections;
    if (directionMode == DirectionMode.ONLY_CARDINAL)
    {
      interestingDirections = Directions.cardinals;
    }
    else if (directionMode == DirectionMode.ONLY_DIAGONAL)
    {
      interestingDirections = Directions.diagonals;
    }
    else
    {
      interestingDirections = Direction.values;
    }

      return interestingDirections.every((direction) => enterAble(position, direction));
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
    return leaveAble(position.go(direction), Directions.turn(direction, 180));
  }

  bool leaveAble(Position position, Direction direction)
  {
    GridMode gridMode = _data.gridMode;
    DirectionMode directionMode = _data.directionMode;
    CornerMode cornerMode = _data.cornerMode;
    DirectionalMode directionalMode = _data.directionalMode;

    if (!position.legal(_data.size))
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
      if (Directions.isDiagonal(direction))
      {
        return false;
      }
    }
    else if (directionMode == DirectionMode.ONLY_DIAGONAL)
    {
      if (Directions.isCardinal(direction))
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

    if (Directions.isDiagonal(direction) && cornerMode == CornerMode.BYPASS)
    {
      bool isCornerBlocked = _enterBlockedDirectly(position, direction)
          || _leaveBlockedDirectly(position.go(Directions.turn(direction, 45)), Directions.turn(direction, -90))
          || _enterBlockedDirectly(position.go(Directions.turn(direction, 45)), Directions.turn(direction, -90));

      if (isCornerBlocked)
      {
        return false;
      }
    }

    return true;
  }

  bool _leaveBlockedDirectly(Position position, Direction direction)
  {
    GridMode gridMode = _data.gridMode;
    Position targetPosition = position.go(direction);
    return !targetPosition.legal(_data.size)
        || !position.legal(_data.size)
        || (gridMode == GridMode.BASIC ? _data.getBarrier(targetPosition).isAnyBlocked() : _data.getBarrier(targetPosition).isBlocked(Directions.turn(direction, 180)));
  }

  bool _enterBlockedDirectly(Position position, Direction direction)
  {
    GridMode gridMode = _data.gridMode;
    Position startPosition = position.go(direction);
    return !startPosition.legal(_data.size)
        || !position.legal(_data.size)
        || (gridMode == GridMode.BASIC ? _data.getBarrier(position).isAnyBlocked() : _data.getBarrier(position).isBlocked(direction));
  }
}
