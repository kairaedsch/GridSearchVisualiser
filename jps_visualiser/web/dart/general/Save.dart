import '../general/Direction.dart';
import '../general/Position.dart';
import '../general/Size.dart';
import 'dart:html';
import 'package:quiver/core.dart';
import 'package:vector_math/vector_math.dart';

class Save
{
  static int scaleWithOutGrid = 45;
  static int scale = scaleWithOutGrid + 1;
  static int footer = 1;
  static List<int> colorBlocked = [0, 149, 255, 1];
  static List<int> colorUnblocked = [255, 255, 255, 1];
  static List<int> colorGrid = [200, 200, 200, 1];

  CanvasElement canvas;
  CanvasRenderingContext2D context;
  Size originalSize;

  Save(this.originalSize)
  {
    canvas = new CanvasElement(width: originalSize.width * scale, height: originalSize.height * scale + footer);
    context = canvas.getContext('2d') as CanvasRenderingContext2D;
    context.setFillColorRgb(colorGrid[0], colorGrid[1], colorGrid[2], colorGrid[3]);
    context.fillRect(0, 0, originalSize.width * scale, originalSize.height * scale);
  }

  Save.load(this.originalSize, String imageSrc, void callback(Save save))
  {
    canvas = new CanvasElement(width: originalSize.width * scale, height: originalSize.height * scale + footer);
    context = canvas.getContext('2d') as CanvasRenderingContext2D;

    ImageElement image = new ImageElement(src: imageSrc);
    image.onLoad.listen((e) {
      context.drawImage(image, 0, 0);
      callback(this);
    });
  }

  String downloadLink()
  {
    return canvas.toDataUrl("image/png", 100);
  }

  void writeBarrier(Position position, Optional<Direction> direction, bool blocked)
  {
    _writeBarrier(position, direction, blocked ? colorBlocked : colorUnblocked);
  }

  void writeData(int pos, SaveData saveData)
  {
    _writePixel(pos, [saveData.saveDataValues.indexOf(saveData) * 10, 0, 0, 1]);
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

  T readData<T>(int pos, List<T> saveDataValues)
  {
    int index = (_readPixel(pos) / 10.0).round().toInt();
    return saveDataValues[index];
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

    context.setFillColorRgb(color[0], color[1], color[2], color[3]);
    context.fillRect(recPosTopLeft.x, recPosTopLeft.y, scaleWithOutGrid / 3.0, scaleWithOutGrid / 3.0);
  }

  void _writePixel(int x, List<int> color)
  {
    context.setFillColorRgb(color[0], color[1], color[2], color[3]);
    context.fillRect(x, originalSize.height * scale,1, 1);
  }

  List<int> _readBarrier(Position position, Direction direction, List<List<int>> colorToFind)
  {
    Vector2 pos = new Vector2(position.x + 0.5, position.y + 0.5)..scale(scale + 0.0);
    Vector2 dir = new Vector2(direction.dx + 0.0, direction.dy + 0.0)..scale(scale * 0.35);

    Vector2 recPosMiddlePix = pos.clone()..add(dir);

    ImageData imageData = context.getImageData(recPosMiddlePix.x, recPosMiddlePix.y, 1, 1);

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

  int _readPixel(int x)
  {
    ImageData imageData = context.getImageData(x, originalSize.height * scale, 1, 1);

    return imageData.data[0];
  }
}

abstract class SaveData<T>
{
  List<T> get saveDataValues;
}