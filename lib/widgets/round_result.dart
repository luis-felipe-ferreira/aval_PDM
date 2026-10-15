import 'package:flutter/material.dart';

import '../game/game_round.dart';
import '../models/game_status.dart';

class RoundResult extends StatelessWidget {
  const RoundResult({
    super.key,
    required this.round,
    required this.onNewRound,
    required this.onChooseOther,
  });

  final GameRound round;
  final VoidCallback onNewRound;
  final VoidCallback onChooseOther;

  @override
  Widget build(BuildContext context) {
    final won = round.status == GameStatus.won;
    return Column(
      children: [
        Text(
          won ? 'Você venceu!' : 'Fim de jogo: você perdeu.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: won ? Colors.green.shade800 : Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Resposta: ${round.answer.text}\n'
          'Erros: ${round.errors}\n'
          'Dica usada: ${round.hintUsed ? 'sim' : 'não'}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            FilledButton(
              onPressed: onNewRound,
              child: const Text('Nova partida'),
            ),
            TextButton(
              onPressed: onChooseOther,
              child: const Text('Trocar opções'),
            ),
          ],
        ),
      ],
    );
  }
}
