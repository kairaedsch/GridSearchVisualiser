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
  bool isActive;
}

@Component()
class ReactDropDownComponent extends UiStatefulComponent<ReactDropDownProps, ReactDropDownState>
{
  @override
  Map getInitialState() => (newState()
    ..isActive = false
  );

  @override
  ReactElement render()
  {
    return (
        Dom.div()
          ..className = ""
              " dropDown"
              " ${state.isActive ? "active" : ""}"
          ..onMouseLeave = ((_) => _setInactive())
    )(
      (Dom.div()
        ..className = "value current"
        ..onClick = ((_) => _toggleActive())
      )(props.value.dropDownName),

      (Dom.div()
        ..className = "drop"
      )(
        (Dom.div()..className = "arrowLine")(),
        (Dom.div()..className = "values")(
            props.values
                .map((value) =>
                (Dom.div()
                  ..className = "value"
                  ..key = value
                  ..onClick = ((_) => _handleValueClick(value))
                )(
                    value.dropDownName
                ))
                .toList()
        ),
      ),
    );
  }

  void _handleValueClick(DropDownElement value) {
    _setInactive();
    props.selectListener(value);
  }

  void _toggleActive() {
    setState(newState()
      ..isActive = !state.isActive
    );
  }

  void _setInactive() {
    setState(newState()
      ..isActive = false
    );
  }
}