import '../general/Direction.dart';
import '../general/Position.dart';
import '../general/Size.dart';
import 'dart:html';
import 'package:quiver/core.dart';
import 'package:vector_math/vector_math.dart';

class Save
{
  static int scaleWithOutGrid = 27;
  static int scale = scaleWithOutGrid + 1;
  static int header = 1;
  static List<int> colorBlocked = [0, 149, 255, 1];
  static List<int> colorUnblocked = [255, 255, 255, 1];
  static List<int> colorGrid = [200, 200, 200, 1];
  static List<int> colorSource = [47, 193, 60, 1];
  static List<int> colorTarget = [202, 4, 4, 1];

  CanvasElement _canvas;
  CanvasRenderingContext2D _context;
  Size _gridSize;
  Size get gridSize => _gridSize;

  Save(this._gridSize)
  {
    _canvas = new CanvasElement(width: gridSize.width * scale, height: gridSize.height * scale + header);
    _context = _canvas.getContext('2d') as CanvasRenderingContext2D;
    _context.setFillColorRgb(colorGrid[0], colorGrid[1], colorGrid[2], colorGrid[3]);
    _context.fillRect(0, 0, gridSize.width * scale, gridSize.height * scale);
  }

  Save.load(String imageSrc, void callback(Save save))
  {
    ImageElement image = new ImageElement(src: imageSrc);
    image.onLoad.listen((e) {
      _gridSize = new Size((image.width / scale).round(), ((image.height - header) / scale).round());
          _canvas = new CanvasElement(width: gridSize.width * scale, height: gridSize.height * scale + header);
      _context = _canvas.getContext('2d') as CanvasRenderingContext2D;
      _context.drawImage(image, 0, 0);
      callback(this);
    });
  }

  String downloadLink()
  {
    return _canvas.toDataUrl("image/png", 100);
  }

  void writeEnum(int pos, SaveData saveData)
  {
    writeInt(pos, saveData.saveDataValues.indexOf(saveData) * 10);
  }

  T readEnum<T>(int pos, List<T> saveEnum)
  {
    int index = (readInt(pos) / 10.0).round().toInt();
    return saveEnum[index];
  }

  void writeInt(int x, int value)
  {
    List<int> color = [value, 255, 255, 1];
    _context.setFillColorRgb(color[0], color[1], color[2], color[3]);
    _context.fillRect(x, 0, 1, 1);
  }

  int readInt(int x)
  {
    ImageData imageData = _context.getImageData(x, 0, 1, 1);

    return imageData.data[0];
  }

  void writeBarrier(Position position, Optional<Direction> direction, bool blocked)
  {
    _writeBarrier(position, direction, blocked ? colorBlocked : colorUnblocked);
  }

  void writeTarget(Position position)
  {
    _writeBarrier(position, new Optional.absent(), colorTarget);
  }

  void writeSource(Position position)
  {
    _writeBarrier(position, new Optional.absent(), colorSource);
  }

  void _writeBarrier(Position position, Optional<Direction> direction, List<int> color)
  {
    Vector2 pos = new Vector2(position.x + 0.0, position.y + 0.0)..scale(scale + 0.0);
    Vector2 dir;
    if (!direction.isPresent)
    {
      dir = new Vector2(1.0, 1.0);
    }
    else
    {
      switch(direction.value)
      {
        case Direction.NORTH: dir = new Vector2(1.0, 0.0); break;
        case Direction.NORTH_EAST: dir = new Vector2(2.0, 0.0); break;
        case Direction.EAST: dir = new Vector2(2.0, 1.0); break;
        case Direction.SOUTH_EAST: dir = new Vector2(2.0, 2.0); break;
        case Direction.SOUTH: dir = new Vector2(1.0, 2.0); break;
        case Direction.SOUTH_WEST: dir = new Vector2(0.0, 2.0); break;
        case Direction.WEST: dir = new Vector2(0.0, 1.0); break;
        case Direction.NORTH_WEST: dir = new Vector2(0.0, 0.0); break;
      }
    }
    dir.scale(scaleWithOutGrid / 3.0);

    Vector2 recPosTopLeft = pos.clone()..add(dir);

    _context.setFillColorRgb(color[0], color[1], color[2], color[3]);
    _context.fillRect(recPosTopLeft.x, header + recPosTopLeft.y, scaleWithOutGrid / 3.0, scaleWithOutGrid / 3.0);
  }

  bool readBarrier(Position position, Direction direction)
  {
    List<List<int>> colors = [colorBlocked, colorUnblocked];
    List<int> color = _readBarrier(position, direction, colors);
    if (color == colorBlocked)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  List<int> _readBarrier(Position position, Direction direction, List<List<int>> colorToFind)
  {
    Vector2 pos = new Vector2(position.x + 0.5, position.y + 0.5)..scale(scale + 0.0);
    Vector2 dir = new Vector2(direction.dx + 0.0, direction.dy + 0.0)..scale(scale * 0.35);

    Vector2 recPosMiddlePix = pos.clone()..add(dir);

    ImageData imageData = _context.getImageData(recPosMiddlePix.x, header + recPosMiddlePix.y, 1, 1);

    var pixel = imageData.data;
    for(List<int> color in colorToFind)
    {
      if (color[0] == pixel[0] && color[1] == pixel[1] && color[2] == pixel[2])
      {
        return color;
      }
    }
    return pixel;
  }
}

abstract class SaveData<T>
{
  List<T> get saveDataValues;
}