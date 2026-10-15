import 'package:flutter/material.dart';

import '../game/game_round.dart';

class GameKeyboard extends StatelessWidget {
  const GameKeyboard({super.key, required this.round});

  final GameRound round;

  @override
  Widget build(BuildContext context) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: letters.split('').map((letter) {
        final used = round.guessedLetters.contains(letter);
        return SizedBox(
          width: 43,
          height: 43,
          child: FilledButton(
            onPressed: used ? null : () => round.guess(letter),
            style: FilledButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(letter),
          ),
        );
      }).toList(),
    );
  }
}
