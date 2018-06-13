import 'package:over_react/over_react.dart';
import 'package:collection/collection.dart';

abstract class PureUiComponent<T extends UiProps> extends UiComponent<T>
{
  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState)
  {
    return propsChanged(props.props, nextProps);
  }
}

abstract class PureUiStatefulComponent<P extends UiProps, S extends UiState> extends UiStatefulComponent<P, S>
{
  static ListEquality listEq = const ListEquality();

  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState)
  {
    return propsChanged(props.props, nextProps) || stateChanged(state.state, nextState);
  }
}

ListEquality listEq = const ListEquality();
bool propsChanged(Map oldProps, Map nextProps) {
  return nextProps.keys.where((key) => key != "children").any((key) => nextProps[key] != oldProps[key])
      || !listEq.equals(nextProps["children"], oldProps["children"]);
}

bool stateChanged(Map oldState, Map nextState) {
  return nextState.keys.any((key) => nextState[key] != oldState[key]);
}