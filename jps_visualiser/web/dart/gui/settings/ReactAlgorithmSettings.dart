import '../../general/transfer/StoreTransferAble.dart';
import '../../model/store/Store.dart';
import '../../model/store/Enums.dart';
import '../../general/gui/ReactDropDown.dart';
import '../../general/gui/ReactPopover.dart';
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactAlgorithmSettingsProps> ReactAlgorithmSettings;

@Props()
class ReactAlgorithmSettingsProps extends UiProps
{
  Store store;
}

@Component()
class ReactAlgorithmSettingsComponent extends UiComponent<ReactAlgorithmSettingsProps>
{
  EqualListener listener;

  @override
  void componentWillMount()
  {
    super.componentWillMount();

    listener = () => redraw();
    props.store.addEqualListener(["algorithmType", "heuristicType", "algorithmUpdateMode", "gridMode", "directionMode", "cornerMode", "directionalMode"], listener);
  }

  @override
  ReactElement render()
  {
    bool useHeuristic = (props.store.algorithmType != AlgorithmType.DIJKSTRA && props.store.algorithmType != AlgorithmType.JPSP_DATA && props.store.algorithmType != AlgorithmType.NO_ALGORITHM);
    bool algorithmSelected = props.store.algorithmType != AlgorithmType.NO_ALGORITHM;
    return
      (Dom.div()..className = "menu")(
        (Dom.div()..className = "title")("Algorithm"),
        (Dom.div()..className = "configs")(
          (ReactPopover()
            ..className = "config"
            ..popover = AlgorithmTypes.popover
          )(
              (Dom.div()..className = "title")("Algorithm:"),
              (ReactDropDown()
                ..value = props.store.algorithmType
                ..values = AlgorithmType.values
                ..getTitle = AlgorithmTypes.getTitle
                ..selectListener = ((dynamic newValue) => props.store.algorithmType = newValue as AlgorithmType)
              )()
          ),
          useHeuristic ?
          (ReactPopover()
            ..className = "config"
            ..popover = HeuristicTypes.popover
          )(
              (Dom.div()..className = "title")("Heuristic:"),
              (ReactDropDown()
                ..value = props.store.heuristicType
                ..values = HeuristicType.values
                ..getTitle = HeuristicTypes.getTitle
                ..selectListener = ((dynamic newValue) => props.store.heuristicType = newValue as HeuristicType)
              )()
          ) : (Dom.div()..className = "config")(),
          algorithmSelected ?
          (ReactPopover()
            ..className = "config"
            ..popover = AlgorithmUpdateModes.popover
          )(
              (Dom.div()..className = "title")("Run:"),
              (ReactDropDown()
                ..value = props.store.algorithmUpdateMode
                ..values = AlgorithmUpdateMode.values
                ..getTitle = AlgorithmUpdateModes.getTitle
                ..selectListener = ((dynamic newValue) => props.store.algorithmUpdateMode = newValue as AlgorithmUpdateMode)
              )()
          ) : null,
          props.store.algorithmUpdateMode == AlgorithmUpdateMode.MANUALLY && algorithmSelected ?
          (ReactPopover()
            ..className = "config small"
            ..popover = "Run the algorithm${useHeuristic ? " with the selected heuristic" : ""}"
          )(
              (Dom.div()
                ..className = "button run"
                ..onClick = ((_) => props.store.triggerTransferListeners())
              )(
                "Run"),
          ) : null,
        )
    );
  }

  @override
  void componentWillUnmount()
  {
    super.componentWillUnmount();

    props.store.removeEqualListener(listener);
  }
}