import 'dart:core' as core;
import 'dart:core';

class Util
{
  static int range(int value, int min, int max)
  {
    return value < min ? min : (value > max ? max : value);
  }

  static void print(dynamic content)
  {
    String now = new DateTime.now().toIso8601String();
    core.print("$now: $content");
  }

  static T notNull<T>(T value, {T orElse()})
  {
    return value != null ? value : orElse();
  }

  static bool equal(dynamic itemOne, dynamic itemTwo)
  {
    if (itemOne == itemTwo)
    {
      return true;
    }
    if (itemOne == null || itemTwo == null)
    {
      return false;
    }
    if (itemOne is Map<String, dynamic> && itemTwo is Map<String, dynamic>)
    {
      return _equalMap(itemOne, itemTwo);
    }
    if (itemOne is List<dynamic> && itemTwo is List<dynamic>)
    {
      return _equalList(itemOne, itemTwo);
    }
    return false;
  }

  static bool _equalList(List<dynamic> listOne, List<dynamic> listTwo)
  {
    if (listOne.length != listTwo.length)
    {
      return false;
    }
    for (int i = 0; i < listOne.length; i++)
    {
      if (!equal(listOne[i], listTwo[i]))
      {
        return false;
      }
    }
    return true;
  }

  static bool _equalMap(Map<String, dynamic> mapOne, Map<String, dynamic> mapTwo)
  {
    if (mapOne.length != mapTwo.length)
    {
      return false;
    }
    for (String key in mapOne.keys)
    {
      dynamic itemOne = mapOne[key];
      dynamic itemTwo = mapTwo[key];
      if (!equal(itemOne, itemTwo))
      {
        return false;
      }
    }
    return true;
  }
}