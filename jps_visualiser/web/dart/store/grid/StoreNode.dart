import '../../general/Position.dart';
import '../../model/history/Highlight.dart';
import '../history/StoreHistory.dart';
import 'StructureNode.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreNode extends Store
{
  final Position position;

  Optional<BoxHighlight> _boxHighlight;
  Optional<BoxHighlight> get boxHighlight => _boxHighlight;

  Optional<CircleHighlight> _circleHighlight;
  Optional<CircleHighlight> get circleHighlight => _circleHighlight;

  Optional<DotHighlight> _dotHighlight;
  Optional<DotHighlight> get dotHighlight => _dotHighlight;

  Optional<TextHighlight> _textHighlight;
  Optional<TextHighlight> get textHighlight => _textHighlight;

  Optional<InfoHighlight> _infoHighlight;
  Optional<InfoHighlight> get infoHighlight => _infoHighlight;

  List<PathHighlight> _pathHighlights;
  List<PathHighlight> get pathHighlights => _pathHighlights;

  StructureNode _structureNode;
  StructureNode get structureNode => _structureNode;

  ActionsNodeChanged _actions;
  ActionsNodeChanged get actions => _actions;

  StoreNode(this.position, ActionsHistory actionsHistory)
  {
    _structureNode = new StructureNode.normal();

    _boxHighlight = const Optional.absent();
    _circleHighlight = const Optional.absent();
    _dotHighlight = const Optional.absent();
    _textHighlight = const Optional.absent();
    _infoHighlight = const Optional.absent();
    _pathHighlights = [];

    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);

    actionsHistory.highlightsChanged.listen(_historyHighlightsChanged);
  }

  void _changeStructureNode(StructureNode structureNode)
  {
    _structureNode = structureNode;
    trigger();
  }

  void _historyHighlightsChanged(List<Highlight> highlights)
  {
    Optional<BoxHighlight> newBoxHighlight = const Optional.absent();
    Optional<CircleHighlight> newCircleHighlight = const Optional.absent();
    Optional<DotHighlight> newDotHighlight = const Optional.absent();
    Optional<TextHighlight> newTextHighlight = const Optional.absent();
    Optional<InfoHighlight> newInfoHighlight = const Optional.absent();
    List<PathHighlight> newPathHighlights = [];

    highlights.forEach((Highlight highlight)
    {
      if (highlight is BoxHighlight)
      {
        if (highlight.positions.contains(position))
        {
          newBoxHighlight = new Optional.of(highlight);
        }
      }
      else if (highlight is CircleHighlight)
      {
        if (highlight.positions.contains(position))
        {
          newCircleHighlight = new Optional.of(highlight);
        }
      }
      else if (highlight is DotHighlight)
      {
        if (highlight.positions.contains(position))
        {
          newDotHighlight = new Optional.of(highlight);
        }
      }
      else if (highlight is TextHighlight)
      {
        if (highlight.position == position)
        {
          newTextHighlight = new Optional.of(highlight);
        }
      }
      else if (highlight is InfoHighlight)
      {
        if (highlight.position == position)
        {
          newInfoHighlight = new Optional.of(highlight);
        }
      }
      else if (highlight is PathHighlight)
      {
        if (highlight.origin.isNotEmpty && highlight.origin.value == position)
        {
          newPathHighlights.add(highlight);
        }
      }
    });

    if (_boxHighlight != newBoxHighlight)
    {
      _boxHighlight = newBoxHighlight;
      trigger();
    }
    if (_circleHighlight != newCircleHighlight)
    {
      _circleHighlight = newCircleHighlight;
      trigger();
    }
    if (_dotHighlight != newDotHighlight)
    {
      _dotHighlight = newDotHighlight;
      trigger();
    }
    if (_textHighlight != newTextHighlight)
    {
      _textHighlight = newTextHighlight;
      trigger();
    }
    if (_infoHighlight != newInfoHighlight)
    {
      _infoHighlight = newInfoHighlight;
      trigger();
    }
    if (_pathHighlights != newPathHighlights && (_pathHighlights.isNotEmpty || newPathHighlights.isNotEmpty))
    {
      _pathHighlights = newPathHighlights;
      trigger();
    }
  }
}

class ActionsNodeChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
}
