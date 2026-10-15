import 'package:flutter/material.dart';

import '../game/game_round.dart';
import '../game/game_session.dart';
import '../models/answer_category.dart';
import '../models/difficulty.dart';
import '../models/game_status.dart';
import '../painters/hangman_painter.dart';
import '../widgets/answer_display.dart';
import '../widgets/game_keyboard.dart';
import '../widgets/round_result.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.round,
    required this.session,
    required this.onNewRound,
    required this.onChooseOther,
  });

  final GameRound round;
  final GameSession session;
  final VoidCallback onNewRound;
  final VoidCallback onChooseOther;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    widget.round.addListener(_roundChanged);
  }

  void _roundChanged() {
    widget.session.recordRound(widget.round);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.round.removeListener(_roundChanged);
    widget.round.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = widget.round;
    final ended = round.status != GameStatus.playing;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            children: [
              Text(
                '${round.answer.category.label} • '
                '${round.answer.difficulty.label}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 190,
                child: CustomPaint(
                  painter: HangmanPainter(round.errors),
                  child: const SizedBox.expand(),
                ),
              ),
              Text(
                'Erros: ${round.errors} / ${GameRound.maxErrors}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              AnswerDisplay(round: round),
              const SizedBox(height: 20),
              if (round.hintUsed)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Dica: ${round.hint}'),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: ended ? null : round.useHint,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Usar dica'),
                ),
              const SizedBox(height: 12),
              if (ended)
                RoundResult(
                  round: round,
                  onNewRound: widget.onNewRound,
                  onChooseOther: widget.onChooseOther,
                )
              else
                GameKeyboard(round: round),
            ],
          ),
        ),
      ),
    );
  }
}
