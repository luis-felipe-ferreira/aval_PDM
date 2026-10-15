import 'answer_category.dart';
import 'difficulty.dart';

class Answer {
  const Answer({
    required this.text,
    required this.category,
    required this.difficulty,
    required this.hints,
  });

  final String text;
  final AnswerCategory category;
  final Difficulty difficulty;
  final List<String> hints;

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['answer'] as String,
      category: AnswerCategory.values.byName(json['category'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      hints: List<String>.from(json['hints'] as List),
    );
  }
}
