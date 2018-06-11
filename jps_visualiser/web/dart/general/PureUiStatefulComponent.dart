import 'package:over_react/over_react.dart';

abstract class PureUiStatefulComponent<P extends UiProps, S extends UiState> extends UiStatefulComponent<P, S>
{
  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState)
  {
    return nextProps.keys.any((key) => nextProps[key].hashCode != props.props[key].hashCode) || nextState.keys.any((key) => nextProps[key].hashCode != state.state[key].hashCode);
  }
}