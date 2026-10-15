enum Difficulty { easy, medium, hard }

extension DifficultyLabel on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Fácil',
        Difficulty.medium => 'Médio',
        Difficulty.hard => 'Difícil',
      };
}
