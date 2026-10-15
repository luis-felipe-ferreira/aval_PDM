import 'package:flutter/material.dart';

class AboutTeamDialog extends StatelessWidget {
  const AboutTeamDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sobre a equipe'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Luis Felipe Ferreira Martins'),
          SizedBox(height: 8),
          Text('Adonias Pereira dos Santos Terceiro'),
        ],
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
