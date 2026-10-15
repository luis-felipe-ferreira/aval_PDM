import 'package:flutter/material.dart';

import '../game/game_round.dart';
import '../game/game_session.dart';
import '../models/answer_category.dart';
import '../models/difficulty.dart';
import '../widgets/about_team_dialog.dart';
import '../widgets/session_stats_dialog.dart';
import 'game_page.dart';
import 'setup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.session});

  final GameSession session;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AnswerCategory _category;
  late Difficulty _difficulty;
  GameRound? _round;

  @override
  void initState() {
    super.initState();
    _category = _availableCategories.first;
    _difficulty = _difficultiesFor(_category).first;
  }

  List<AnswerCategory> get _availableCategories =>
      widget.session.answers.map((answer) => answer.category).toSet().toList();

  List<Difficulty> _difficultiesFor(AnswerCategory category) =>
      widget.session.answers
          .where((answer) => answer.category == category)
          .map((answer) => answer.difficulty)
          .toSet()
          .toList();

  void _startRound() {
    final round = widget.session.startRound(_category, _difficulty);
    if (round == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as respostas dessa opção já foram usadas.'),
        ),
      );
      return;
    }
    setState(() => _round = round);
  }

  void _showStats() {
    showDialog<void>(
      context: context,
      builder: (_) => SessionStatsDialog(session: widget.session),
    );
  }

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (_) => const AboutTeamDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final round = _round;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
        actions: [
          IconButton(
            onPressed: _showStats,
            tooltip: 'Estatísticas',
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            onPressed: _showAbout,
            tooltip: 'Sobre',
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: round == null
            ? SetupPage(
                categories: _availableCategories,
                difficulties: _difficultiesFor(_category),
                selectedCategory: _category,
                selectedDifficulty: _difficulty,
                onCategoryChanged: _selectCategory,
                onDifficultyChanged: (value) =>
                    setState(() => _difficulty = value),
                onStart: _startRound,
                onShowStats: _showStats,
              )
            : GamePage(
                key: ObjectKey(round),
                round: round,
                session: widget.session,
                onNewRound: _returnToSetup,
                onChooseOther: _returnToSetup,
              ),
      ),
    );
  }

  void _selectCategory(AnswerCategory category) {
    setState(() {
      _category = category;
      final difficulties = _difficultiesFor(category);
      if (!difficulties.contains(_difficulty)) {
        _difficulty = difficulties.first;
      }
    });
  }

  void _returnToSetup() {
    setState(() => _round = null);
  }
}
