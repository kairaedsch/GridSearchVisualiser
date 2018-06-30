import 'gui/DropDownElement.dart';

class Bool implements DropDownElement
{
  static const Bool TRUE = const Bool(true, "TRUE", "yes");
  static const Bool FALSE = const Bool(false, "FALSE", "no");

  final bool value;

  final String name;
  String toString() => name;

  final String dropDownName;

  const Bool(this.value, this.name, this.dropDownName);

  static const List<Bool> values = const <Bool>[TRUE, FALSE];
}