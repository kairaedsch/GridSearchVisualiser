import '../../general/Position.dart';
import '../../model/history/Highlight.dart';
import '../history/HistoryPart.dart';
import '../history/StoreHistory.dart';
import 'ExplanationNode.dart';
import 'StructureNode.dart';
import 'package:quiver/core.dart';
import 'package:w_flux/w_flux.dart';

class StoreNode extends Store
{
  final Position position;

  Optional<PositionHighlight> _positionHighlight;
  Optional<PositionHighlight> get positionHighlight => _positionHighlight;

  Optional<TextHighlight> _textHighlight;
  Optional<TextHighlight> get textHighlight => _textHighlight;

  StructureNode _structureNode;
  StructureNode get structureNode => _structureNode;

  ExplanationNode _explanationNode;
  ExplanationNode get explanationNode => _explanationNode;

  ActionsNodeChanged _actions;
  ActionsNodeChanged get actions => _actions;

  StoreNode(this.position, ActionsHistory actionsHistory)
  {
    _structureNode = new StructureNode.normal();
    _explanationNode = const ExplanationNode.normal();
    _positionHighlight = const Optional.absent();
    _textHighlight = const Optional.absent();

    _actions = new ActionsNodeChanged();
    _actions.structureNodeChanged.listen(_changeStructureNode);
    _actions.explanationNodeChanged.listen(_changeExplanationNode);

    actionsHistory.activeChanged.listen(_historyActiveChanged);
    actionsHistory.highlightsChanged.listen(_historyHighlightsChanged);
  }

  void _changeStructureNode(StructureNode structureNode)
  {
    _structureNode = structureNode;
    trigger();
  }

  void _changeExplanationNode(Optional<ExplanationNode> explanationNode)
  {
    if (explanationNode.isPresent)
    {
      if (_explanationNode != explanationNode.value)
      {
        _explanationNode = explanationNode.value;
        trigger();
      }
    }
    else if (_explanationNode != const ExplanationNode.normal())
    {
      _explanationNode = const ExplanationNode.normal();
      trigger();
    }
  }

  void _historyActiveChanged(Optional<HistoryPart> part)
  {
    actions.explanationNodeChanged(part.transform((p) => p.explanationNodes[position]));
  }

  void _historyHighlightsChanged(List<Highlight> highlights)
  {
    Optional<PositionHighlight> newPositionHighlight = const Optional.absent();
    Optional<TextHighlight> newTextHighlight = const Optional.absent();

    highlights.forEach((Highlight highlight)
    {
      if (highlight is PositionHighlight)
      {
        if (highlight.positions.contains(position))
        {
          newPositionHighlight = new Optional.of(highlight);
        }
      }
      if (highlight is TextHighlight)
      {
        if (highlight.position == position)
        {
          newTextHighlight = new Optional.of(highlight);
        }
      }
    });

    if (_positionHighlight != newPositionHighlight)
    {
      _positionHighlight = newPositionHighlight;
      trigger();
    }

    if (_textHighlight != newTextHighlight)
    {
      _textHighlight = newTextHighlight;
      trigger();
    }
  }
}

class ActionsNodeChanged
{
  final Action<StructureNode> structureNodeChanged = new Action<StructureNode>();
  final Action<Optional<ExplanationNode>> explanationNodeChanged = new Action<Optional<ExplanationNode>>();
}
