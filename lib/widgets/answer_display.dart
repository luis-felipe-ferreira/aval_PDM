import 'package:flutter/material.dart';

import '../game/answer_text.dart';
import '../game/game_round.dart';

class AnswerDisplay extends StatelessWidget {
  const AnswerDisplay({super.key, required this.round});

  final GameRound round;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 7,
      runSpacing: 12,
      children: round.answer.text.split('').map((character) {
        final shown = round.isRevealed(character);
        if (!AnswerText.isLetter(character)) {
          return SizedBox(
            width: character == ' ' ? 18 : 24,
            child: Center(
              child: Text(character, style: const TextStyle(fontSize: 27)),
            ),
          );
        }
        return Container(
          width: 29,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 2)),
          ),
          child: Text(
            shown ? character : ' ',
            style: const TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }
}
