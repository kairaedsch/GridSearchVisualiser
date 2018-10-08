@JS()
library tooltip;

import 'dart:html';
import 'package:uuid/uuid.dart';
import 'package:js/js.dart';
import 'package:over_react/over_react.dart';

@JS("document.getElementById")
external dynamic getElementById(String id);

@JS()
class Tooltip {
  external Tooltip(dynamic reference, TooltipOptions options);
  external dynamic show();
  external dynamic hide();
  external dynamic dispose();
  external dynamic toggle();
  external dynamic updateTitleContent(String newTitle);
}

@JS()
@anonymous
class TooltipOptions {
  external String get placement;
  external String get arrowSelector;
  external String get innerSelector;
  external dynamic get container;
  external dynamic get delay;
  external bool get html;
  external String get template;
  external dynamic get title;
  external String get trigger;
  external bool get closeOnClickOutside;
  external dynamic get boundariesElement;
  external dynamic get offset;
  external dynamic get popperOptions;

  external factory TooltipOptions({
    String placement,
    String arrowSelector,
    String innerSelector,
    dynamic container,
    dynamic delay,
    bool html,
    String template,
    dynamic title,
    String trigger,
    bool closeOnClickOutside,
    dynamic boundariesElement,
    dynamic offset,
    dynamic popperOptions
  });
}

@Factory()
UiFactory<ReactPopoverProps> ReactPopover;

@Props()
class ReactPopoverProps extends UiProps
{
  String popover;
}


@Component()
class ReactPopoverComponent extends UiComponent<ReactPopoverProps>
{
  static int ids = 0;
  String id = "id_${ids++}";
  Tooltip tooltip = null;

  @override
  Map getInitialProps() =>
      (newProps()
        ..popover = "Fill me"
      );

  @override
  ReactElement render()
  {
    return
      (Dom.div()
        ..addProps(props.props)
        ..remove("ReactPopoverProps.popover")
        ..id = id
      )(
        props.children
      );
  }

  @override
  void componentDidMount()
  {
    super.componentDidMount();
    _createTooltip();
  }

  @override
  void componentDidUpdate(Map prevProps, Map prevState) {
    super.componentDidUpdate(prevProps, prevState);
    _createTooltip();
  }

  @override
  void componentWillUpdate(Map prevProps, Map prevState) {
    super.componentDidUpdate(prevProps, prevState);
    _disposeTooltip();
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();
    _disposeTooltip();
  }

  void _disposeTooltip()
  {
    if (tooltip != null)
    {
      tooltip.dispose();
    }
  }

  void _createTooltip()
  {
    tooltip = new Tooltip(getElementById(id), new TooltipOptions(title: "${props.popover}", container: getElementById("body")));
  }
}