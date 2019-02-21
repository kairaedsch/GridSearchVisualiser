@JS()
library tooltip;

import 'package:js/js.dart';
import 'package:over_react/over_react.dart';
// ignore: uri_has_not_been_generated
part 'ReactPopover.over_react.g.dart';

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
UiFactory<ReactPopoverProps> ReactPopover = _$ReactPopover;

@Props()
class _$ReactPopoverProps extends UiProps
{
  String popover;
  bool html;
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
        ..html = false
      );

  @override
  ReactElement render()
  {
    return
      (Dom.div()
        ..addProps(props.props)
        ..remove("ReactPopoverProps.popover")
        ..remove("ReactPopoverProps.html")
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
    String content;
    String placement;
    if (props.html == true)
    {
      content = "${props.popover}";
      placement = "left";
    }
    else
    {
      content = "<div class='title'>${props.popover}</div>";
      placement = "top";
    }
    tooltip = new Tooltip(getElementById(id), new TooltipOptions(title: content, container: getElementById("body"), placement: placement, html: true));
  }
}