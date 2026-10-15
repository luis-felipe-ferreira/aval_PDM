import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/answer.dart';

class AnswerRepository {
  Future<List<Answer>> loadAnswers() async {
    final jsonText =
        await rootBundle.loadString('assets/data/hangman_entries.json');
    final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
    final entries = jsonData['entries'] as List<dynamic>;

    return entries
        .map((item) => Answer.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
