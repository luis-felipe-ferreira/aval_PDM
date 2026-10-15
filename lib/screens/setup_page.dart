import 'package:flutter/material.dart';

import '../models/answer_category.dart';
import '../models/difficulty.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({
    super.key,
    required this.categories,
    required this.difficulties,
    required this.selectedCategory,
    required this.selectedDifficulty,
    required this.onCategoryChanged,
    required this.onDifficultyChanged,
    required this.onStart,
    required this.onShowStats,
  });

  final List<AnswerCategory> categories;
  final List<Difficulty> difficulties;
  final AnswerCategory selectedCategory;
  final Difficulty selectedDifficulty;
  final ValueChanged<AnswerCategory> onCategoryChanged;
  final ValueChanged<Difficulty> onDifficultyChanged;
  final VoidCallback onStart;
  final VoidCallback onShowStats;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.extension, size: 72, color: Color(0xFF146C70)),
              const SizedBox(height: 12),
              Text(
                'Prepare a partida',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<AnswerCategory>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) onCategoryChanged(value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Difficulty>(
                key: ValueKey(selectedCategory),
                initialValue: selectedDifficulty,
                decoration: const InputDecoration(
                  labelText: 'Dificuldade',
                  border: OutlineInputBorder(),
                ),
                items: difficulties
                    .map((difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty.label),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) onDifficultyChanged(value);
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar partida'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onShowStats,
                icon: const Icon(Icons.bar_chart),
                label: const Text('Ver estatísticas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
