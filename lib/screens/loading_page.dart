import 'package:flutter/material.dart';

import '../data/answer_repository.dart';
import '../game/game_session.dart';
import '../models/answer.dart';
import 'home_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final Future<List<Answer>> _answers = AnswerRepository().loadAnswers();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Answer>>(
      future: _answers,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar as respostas.\n'
                  'Confira o arquivo JSON e tente abrir o app novamente.\n\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'O arquivo de respostas está vazio. '
                  'Adicione respostas ao JSON e abra o app novamente.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return HomePage(session: GameSession(snapshot.data!));
      },
    );
  }
}
