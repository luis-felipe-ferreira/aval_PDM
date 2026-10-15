import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/answer.dart';
import '../models/answer_category.dart';
import '../models/difficulty.dart';
import '../models/game_status.dart';
import 'game_round.dart';

class GameSession extends ChangeNotifier {
  GameSession(this.answers);

  final List<Answer> answers;
  final Set<String> _usedAnswers = {};
  int rounds = 0;
  int wins = 0;
  int losses = 0;
  int totalErrors = 0;
  int hintsUsed = 0;

  GameRound? startRound(AnswerCategory category, Difficulty difficulty) {
    final key = '${category.name}|${difficulty.name}';
    final available = answers
        .where((answer) =>
            answer.category == category &&
            answer.difficulty == difficulty &&
            !_usedAnswers.contains('$key|${answer.text}'))
        .toList();

    if (available.isEmpty) return null;

    final answer = available[Random().nextInt(available.length)];
    _usedAnswers.add('$key|${answer.text}');
    return GameRound(answer);
  }

  void recordRound(GameRound round) {
    if (round.status == GameStatus.playing || round.statsRecorded) return;
    round.statsRecorded = true;
    rounds++;
    totalErrors += round.errors;
    if (round.hintUsed) hintsUsed++;
    if (round.status == GameStatus.won) {
      wins++;
    } else {
      losses++;
    }
    notifyListeners();
  }

  double get winPercent => rounds == 0 ? 0 : wins * 100 / rounds;
  double get lossPercent => rounds == 0 ? 0 : losses * 100 / rounds;
}
