import 'package:over_react/over_react.dart';

abstract class PureUiComponent<T extends UiProps> extends UiComponent<T>
{
  @override
  bool shouldComponentUpdate(Map nextProps, Map nextState)
  {
    return nextProps.keys.any((key) => nextProps[key] != props.props[key]);
  }
}