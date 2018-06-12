import 'package:over_react/over_react.dart';
import 'package:collection/collection.dart';

abstract class PureUiComponent<T extends UiProps> extends UiComponent<T>
{
  static ListEquality listEq = const ListEquality();

  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState)
  {
    return nextProps.keys.where((key) => key != "children").any((key) => nextProps[key] != props.props[key])
          || !listEq.equals(nextProps["children"], props.props["children"]);
  }
}