import '../../../Settings.dart';
import '../../../general/general/Util.dart';
import '../../../general/geo/Size.dart';
import '../Store.dart';
import '../../../general/geo/Position.dart';

class GridManager
{
  final Store _store;

  GridManager(this._store);

  void setSize(Size newMaybeSize)
  {
    Size newSize = new Size(Util.range(newMaybeSize.width, Settings.minSize.width, Settings.maxSize.width), Util.range(newMaybeSize.height, Settings.minSize.height, Settings.maxSize.height));

    Position newStartPosition = new Position(Util.range(_store.startPosition.x, 0, newSize.width - 1), Util.range(_store.startPosition.y, 0, newSize.height - 1));
    Position newTargetPosition = new Position(Util.range(_store.targetPosition.x, 0, newSize.width - 1), Util.range(_store.targetPosition.y, 0, newSize.height - 1));
    if (newStartPosition == newTargetPosition)
    {
      newStartPosition = newTargetPosition != new Position(0, 0) ? new Position(0, 0) : new Position(1, 1);
    }

    if (_store.autoTriggerListeners)
    {
      _store.autoTriggerListeners = false;
      _store.size = newSize;
      _store.startPosition = newStartPosition;
      _store.targetPosition = newTargetPosition;
      _store.autoTriggerListeners = true;
      _store.triggerListeners();
    }
    else
    {
      _store.size = newSize;
      _store.startPosition = newStartPosition;
      _store.targetPosition = newTargetPosition;
    }
  }

  void setStartPosition(Position newStartPosition)
  {
    if (newStartPosition.legal(_store.size) && newStartPosition != _store.targetPosition)
    {
      _store.startPosition = newStartPosition;
    }
  }

  void setTargetPosition(Position newTargetPosition)
  {
    if (newTargetPosition.legal(_store.size) && newTargetPosition != _store.startPosition)
    {
      _store.targetPosition = newTargetPosition;
    }
  }
}
