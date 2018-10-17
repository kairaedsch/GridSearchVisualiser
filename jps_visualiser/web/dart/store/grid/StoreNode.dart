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

  List<DirectionTextHighlight> _directionTextHighlights;
  List<DirectionTextHighlight> get directionTextHighlights => _directionTextHighlights;

  StructureNode _structureNode;
  StructureNode get structureNode => _structureNode;

  ActionsNodeChanged _actions;
  ActionsNodeChanged get actions => _actions;

  StoreNode(this.position, ActionsHistory actionsHistory, Function runAlgorithm)
  {
    _structureNode = new StructureNode.normal();

    _boxHighlight = const Optional.absent();
    _circleHighlight = const Optional.absent();
    _dotHighlight = const Optional.absent();
    _textHighlight = const Optional.absent();
    _infoHighlight = const Optional.absent();
    _pathHighlights = [];
    _directionTextHighlights = [];

    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);

    actionsHistory.highlightsChanged.listen(_historyHighlightsChanged);

    _actions.structureNodeChanged.listen((_) => runAlgorithm());
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
    List<DirectionTextHighlight> newDirectionTextHighlights = [];

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
      else if (highlight is DirectionTextHighlight)
      {
        if (highlight.position == position)
        {
          newDirectionTextHighlights.add(highlight);
        }
      }
    });

    if (_boxHighlight != newBoxHighlight)
    {
      trigger();
      print("_boxHighlight");
    }
    else if (_circleHighlight != newCircleHighlight)
    {
      trigger();
      print("_circleHighlight");
    }
    else if (_dotHighlight != newDotHighlight)
    {
      trigger();
      print("_dotHighlight");
    }
    else if (_textHighlight != newTextHighlight)
    {
      trigger();
      print("_textHighlight");
    }
    else if (_infoHighlight != newInfoHighlight)
    {
      trigger();
      print("_infoHighlight");
    }
    else if (_pathHighlights != newPathHighlights && (_pathHighlights.isNotEmpty || newPathHighlights.isNotEmpty))
    {
      trigger();
      print("_pathHighlights");
    }
    else if (_directionTextHighlights != newDirectionTextHighlights && (_directionTextHighlights.isNotEmpty || newDirectionTextHighlights.isNotEmpty))
    {
      trigger();
      print("_directionTextHighlights");
    }

    _boxHighlight = newBoxHighlight;
    _circleHighlight = newCircleHighlight;
    _dotHighlight = newDotHighlight;
    _textHighlight = newTextHighlight;
    _infoHighlight = newInfoHighlight;
    _pathHighlights = newPathHighlights;
    _directionTextHighlights = newDirectionTextHighlights;
  }
}

class ActionsNodeChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
}
