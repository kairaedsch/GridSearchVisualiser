import 'package:over_react/over_react.dart';
import 'package:collection/collection.dart';

abstract class PureUiStatefulComponent<P extends UiProps, S extends UiState> extends UiStatefulComponent<P, S>
{
  static ListEquality listEq = const ListEquality();

  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState)
  {
    return nextProps.keys.where((key) => key != "children").any((key) => nextProps[key].hashCode != props.props[key].hashCode)
        || nextState.keys.any((key) => nextProps[key].hashCode != state.state[key].hashCode)
        || !listEq.equals(nextProps["children"], props.props["children"]);
  }
}