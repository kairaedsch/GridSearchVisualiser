import '../../general/transfer/StoreTransferAble.dart';
import '../../model/store/Store.dart';
import '../../model/store/Enums.dart';
import '../../general/gui/ReactDropDown.dart';
import '../../general/gui/ReactPopover.dart';
import 'package:over_react/over_react.dart';
// ignore: uri_has_not_been_generated
part 'ReactAlgorithmSettings.over_react.g.dart';

@Factory()
UiFactory<ReactAlgorithmSettingsProps> ReactAlgorithmSettings = _$ReactAlgorithmSettings;

@Props()
class _$ReactAlgorithmSettingsProps extends UiProps
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
    bool useHeuristic = (props.store.algorithmType != AlgorithmType.DIJKSTRA && props.store.algorithmType != AlgorithmType.DJPS_PC && props.store.algorithmType != AlgorithmType.NO_ALGORITHM);
    bool algorithmSelected = props.store.algorithmType != AlgorithmType.NO_ALGORITHM;
    return
      (Dom.div()..className = "menu")(
        (Dom.div()..className = "title")("Algorithm"),
        (Dom.div()..className = "configs")(
          (ReactPopover()
            ..className = "config"
            ..popover = AlgorithmTypes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Algorithm:"),
              (ReactDropDown()
                ..value = props.store.algorithmType
                ..values = AlgorithmType.values
                ..getTitle = ((dynamic e) => AlgorithmTypes.getTitle(e as AlgorithmType))
                ..selectListener = ((dynamic newValue) => props.store.algorithmType = newValue as AlgorithmType)
              )()
          ),
          useHeuristic ?
          (ReactPopover()
            ..className = "config"
            ..popover = HeuristicTypes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Heuristic:"),
              (ReactDropDown()
                ..value = props.store.heuristicType
                ..values = HeuristicType.values
                ..getTitle = ((dynamic e) => HeuristicTypes.getTitle(e as HeuristicType))
                ..selectListener = ((dynamic newValue) => props.store.heuristicType = newValue as HeuristicType)
              )()
          ) : (Dom.div()..className = "config")(),
          algorithmSelected ?
          (ReactPopover()
            ..className = "config"
            ..popover = AlgorithmUpdateModes.popover
            ..html = true
          )(
              (Dom.div()..className = "title")("Run:"),
              (ReactDropDown()
                ..value = props.store.algorithmUpdateMode
                ..values = AlgorithmUpdateMode.values
                ..getTitle = ((dynamic e) => AlgorithmUpdateModes.getTitle(e as AlgorithmUpdateMode))
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