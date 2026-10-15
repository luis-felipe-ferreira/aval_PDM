import 'package:flutter/foundation.dart';

import '../models/answer.dart';
import '../models/game_status.dart';
import 'answer_text.dart';

class GameRound extends ChangeNotifier {
  GameRound(this.answer);

  static const int maxErrors = 6;

  final Answer answer;
  final Set<String> guessedLetters = {};
  int errors = 0;
  bool hintUsed = false;
  bool statsRecorded = false;

  GameStatus get status {
    if (hasWon) return GameStatus.won;
    if (errors >= maxErrors) return GameStatus.lost;
    return GameStatus.playing;
  }

  bool get hasWon => answer.text.split('').every((character) {
        if (!AnswerText.isLetter(character)) return true;
        return guessedLetters.contains(AnswerText.normalize(character));
      });

  String get hint => answer.hints.first;

  void guess(String input) {
    if (!AnswerText.isLetter(input)) return;

    final letter = AnswerText.normalize(input);
    if (status != GameStatus.playing || guessedLetters.contains(letter)) {
      return;
    }

    guessedLetters.add(letter);
    final exists = answer.text
        .split('')
        .any((character) => AnswerText.normalize(character) == letter);
    if (!exists) errors++;
    notifyListeners();
  }

  void useHint() {
    if (status != GameStatus.playing || hintUsed) return;
    hintUsed = true;
    notifyListeners();
  }

  bool isRevealed(String character) {
    return !AnswerText.isLetter(character) ||
        guessedLetters.contains(AnswerText.normalize(character)) ||
        status == GameStatus.lost;
  }
}
