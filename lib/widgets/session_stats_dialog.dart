import 'package:flutter/material.dart';

import '../game/game_session.dart';

class SessionStatsDialog extends StatelessWidget {
  const SessionStatsDialog({super.key, required this.session});

  final GameSession session;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Estatísticas da sessão'),
      content: AnimatedBuilder(
        animation: session,
        builder: (context, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rodadas: ${session.rounds}'),
            Text('Vitórias: ${session.wins} '
                '(${session.winPercent.toStringAsFixed(0)}%)'),
            Text('Derrotas: ${session.losses} '
                '(${session.lossPercent.toStringAsFixed(0)}%)'),
            Text('Erros: ${session.totalErrors}'),
            Text('Dicas usadas: ${session.hintsUsed}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
