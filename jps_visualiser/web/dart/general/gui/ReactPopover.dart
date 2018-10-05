import 'DropDownElement.dart';
import 'package:over_react/over_react.dart';

typedef SelectListener = void Function(DropDownElement newValue);

@Factory()
UiFactory<ReactPopoverProps> ReactPopover;

@Props()
class ReactPopoverProps extends UiProps
{

}

@State()
class ReactPopoverState extends UiState
{
  int height;
}

@Component()
class ReactPopoverComponent extends UiStatefulComponent<ReactPopoverProps, ReactPopoverState>
{
  @override
  Map getInitialState() =>
      (newState()
        ..height = 60
      );

  @override
  ReactElement render()
  {
    if (props.children == null || props.children.isEmpty)
    {
      return null;
    }

    return
      (Dom.div()
        ..className = "popover"
        ..style =
        <String, String>
        {
          "marginTop": "-${state.height}px"
        }
      )(
          (ResizeSensor()
            ..onResize = _resized
            ..onInitialize = _resized
          )(
              (Dom.div()
                ..className = "content"
              )(
                  props.children
              ),
              (Dom.div()
                ..className = "arrow"
              )()
          )
      );
  }

  void _resized(ResizeSensorEvent event)
  {
    print("\n ${event.newHeight}");
    setState(newState()
      ..height = event.newHeight
    );
  }
}