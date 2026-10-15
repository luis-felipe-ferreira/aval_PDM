enum AnswerCategory { animals, humanBody, sports, technology }

extension AnswerCategoryLabel on AnswerCategory {
  String get label => switch (this) {
        AnswerCategory.animals => 'Animais',
        AnswerCategory.humanBody => 'Corpo humano',
        AnswerCategory.sports => 'Esportes',
        AnswerCategory.technology => 'Tecnologia',
      };
}
