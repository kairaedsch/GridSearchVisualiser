import 'DropDownElement.dart';
import 'package:over_react/over_react.dart';

typedef SelectListener = void Function(DropDownElement newValue);

@Factory()
UiFactory<ReactDropDownProps> ReactDropDown;

@Props()
class ReactDropDownProps extends UiProps
{
  DropDownElement value;
  List<DropDownElement> values;
  SelectListener selectListener;
}

@State()
class ReactDropDownState extends UiState
{
  bool isOpen;
  int width;
}

@Component()
class ReactDropDownComponent extends UiStatefulComponent<ReactDropDownProps, ReactDropDownState>
{
  @override
  Map getInitialState() =>
      (newState()
        ..isOpen = false
        ..width = 50
      );

  @override
  ReactElement render()
  {
    return
      (Dom.div()
        ..className = "dropDown"
            " ${state.isOpen ? "open" : ""}"
        ..onMouseLeave = ((_) => _setClosed())
      )(
          (ResizeSensor()
            ..onResize = _resized
            ..onInitialize = _resized
            ..isFlexChild = true
          )(
            (Dom.div()
              ..className = "value current"
              ..onClick = ((_) => _toggleOpen())
            )(
                props.value.dropDownName
            ),
            (Dom.div()
              ..className = "drop"
              ..style =
              <String, String>
              {
                "width": "${state.width}px"
              }
            )(
              (Dom.div()..className = "arrowLine")(),
              (Dom.div()
                ..className = "values")(
                  props.values
                      .map((value) =>
                      (Dom.div()
                        ..className = "value"
                            " ${props.value == value ? "selected" : ""}"
                        ..key = value
                        ..onClick = ((_) => _handleValueClick(value))
                      )(
                          value.dropDownName
                      ))
                      .toList()
              ),
            ),
          )
      );
  }

  ResizeSensorHandler _resized(ResizeSensorEvent event)
  {
    setState(newState()
      ..width = event.newWidth
    );
  }

  void _handleValueClick(DropDownElement value)
  {
    _setClosed();
    if (value != props.value)
    {
      props.selectListener(value);
    }
  }

  void _toggleOpen()
  {
    setState(newState()
      ..isOpen = !state.isOpen
    );
  }

  void _setClosed()
  {
    setState(newState()
      ..isOpen = false
    );
  }
}