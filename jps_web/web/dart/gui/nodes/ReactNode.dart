import '../store/Node.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactNodeProps> ReactNode;

@Props()
class ReactNodeProps extends UiProps
{
  Node node;
}

@Component()
class ReactNodeComponent extends UiComponent<ReactNodeProps>
{
  @override
  render()
  {
    return (Dom.div()
      ..className = "node")();
  }
}