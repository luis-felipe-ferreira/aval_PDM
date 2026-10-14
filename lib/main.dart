import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const HangmanApp());
}

// Estes enums representam os valores fechados que vêm do JSON.
enum AnswerCategory { animals, humanBody, sports, technology }

enum Difficulty { easy, medium, hard }

enum GameStatus { playing, won, lost }

extension AnswerCategoryLabel on AnswerCategory {
  String get label => switch (this) {
        AnswerCategory.animals => 'Animais',
        AnswerCategory.humanBody => 'Corpo humano',
        AnswerCategory.sports => 'Esportes',
        AnswerCategory.technology => 'Tecnologia',
      };
}

extension DifficultyLabel on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Fácil',
        Difficulty.medium => 'Médio',
        Difficulty.hard => 'Difícil',
      };
}

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

  // Transforma um item do JSON em um objeto Dart.
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['answer'] as String,
      category: AnswerCategory.values.byName(json['category'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      hints: List<String>.from(json['hints'] as List),
    );
  }
}

class AnswerRepository {
  // O JSON é lido do asset local. Não há acesso à internet.
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

  // Compara sem acento, mas mantém answer.text original para exibição.
  bool get hasWon => answer.text.split('').every((character) {
        if (!_isLetter(character)) return true;
        return guessedLetters.contains(_normalize(character));
      });

  String get hint => answer.hints.first;

  void guess(String input) {
    final letter = _normalize(input);
    if (status != GameStatus.playing || guessedLetters.contains(letter)) {
      return;
    }

    guessedLetters.add(letter);
    final exists = answer.text
        .split('')
        .any((character) => _normalize(character) == letter);
    if (!exists) errors++;
    notifyListeners();
  }

  void useHint() {
    if (status != GameStatus.playing || hintUsed) return;
    hintUsed = true;
    notifyListeners();
  }

  bool isRevealed(String character) {
    return !_isLetter(character) ||
        guessedLetters.contains(_normalize(character)) ||
        status == GameStatus.lost;
  }

  static bool _isLetter(String character) =>
      RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ]$').hasMatch(character);

  static String _normalize(String character) {
    final upper = character.toUpperCase();
    const accents = {
      'Á': 'A',
      'À': 'A',
      'Â': 'A',
      'Ã': 'A',
      'Ä': 'A',
      'É': 'E',
      'È': 'E',
      'Ê': 'E',
      'Ë': 'E',
      'Í': 'I',
      'Ì': 'I',
      'Î': 'I',
      'Ï': 'I',
      'Ó': 'O',
      'Ò': 'O',
      'Ô': 'O',
      'Õ': 'O',
      'Ö': 'O',
      'Ú': 'U',
      'Ù': 'U',
      'Û': 'U',
      'Ü': 'U',
      'Ç': 'C',
    };
    return accents[upper] ?? upper;
  }
}

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

  // Cada rodada concluída só entra nas estatísticas uma vez.
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

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Forca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF146C70)),
        useMaterial3: true,
      ),
      home: const LoadingPage(),
    );
  }
}

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
                    textAlign: TextAlign.center),
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
                  'O arquivo de respostas está vazio. Adicione respostas ao JSON e abra o app novamente.',
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
            content: Text('Todas as respostas dessa opção já foram usadas.')),
      );
      return;
    }
    setState(() => _round = round);
  }

  void _showStats() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estatísticas da sessão'),
        content: AnimatedBuilder(
          animation: widget.session,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rodadas: ${widget.session.rounds}'),
              Text('Vitórias: ${widget.session.wins} '
                  '(${widget.session.winPercent.toStringAsFixed(0)}%)'),
              Text('Derrotas: ${widget.session.losses} '
                  '(${widget.session.lossPercent.toStringAsFixed(0)}%)'),
              Text('Erros: ${widget.session.totalErrors}'),
              Text('Dicas usadas: ${widget.session.hintsUsed}'),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'))
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
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
              child: const Text('Fechar'))
        ],
      ),
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
              icon: const Icon(Icons.bar_chart)),
          IconButton(
              onPressed: _showAbout,
              tooltip: 'Sobre',
              icon: const Icon(Icons.info_outline)),
        ],
      ),
      body: SafeArea(
        child: round == null
            ? _buildSetup()
            : GamePage(
                key: ObjectKey(round),
                round: round,
                session: widget.session,
                onNewRound: () => setState(() => _round = null),
                onChooseOther: () => setState(() => _round = null),
              ),
      ),
    );
  }

  Widget _buildSetup() {
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
              Text('Prepare a partida',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              DropdownButtonFormField<AnswerCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                    labelText: 'Categoria', border: OutlineInputBorder()),
                items: _availableCategories
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _category = value;
                    final difficulties = _difficultiesFor(value);
                    if (!difficulties.contains(_difficulty)) {
                      _difficulty = difficulties.first;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Difficulty>(
                key: ValueKey(_category),
                initialValue: _difficulty,
                decoration: const InputDecoration(
                    labelText: 'Dificuldade', border: OutlineInputBorder()),
                items: _difficultiesFor(_category)
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _difficulty = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _startRound,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar partida'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _showStats,
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

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.round,
    required this.session,
    required this.onNewRound,
    required this.onChooseOther,
  });

  final GameRound round;
  final GameSession session;
  final VoidCallback onNewRound;
  final VoidCallback onChooseOther;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    widget.round.addListener(_roundChanged);
  }

  void _roundChanged() {
    widget.session.recordRound(widget.round);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.round.removeListener(_roundChanged);
    widget.round.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = widget.round;
    final ended = round.status != GameStatus.playing;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            children: [
              Text(
                  '${round.answer.category.label} • ${round.answer.difficulty.label}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 190,
                child: CustomPaint(
                  painter: HangmanPainter(round.errors),
                  child: const SizedBox.expand(),
                ),
              ),
              Text('Erros: ${round.errors} / ${GameRound.maxErrors}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 7,
                runSpacing: 12,
                children: round.answer.text.split('').map((character) {
                  final shown = round.isRevealed(character);
                  if (!_isLetter(character)) {
                    return SizedBox(
                      width: character == ' ' ? 18 : 24,
                      child: Center(
                          child: Text(character,
                              style: const TextStyle(fontSize: 27))),
                    );
                  }
                  return Container(
                    width: 29,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2)),
                    ),
                    child: Text(shown ? character : ' ',
                        style: const TextStyle(fontSize: 24)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (round.hintUsed)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Dica: ${round.hint}'),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: ended ? null : () => round.useHint(),
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Usar dica'),
                ),
              const SizedBox(height: 12),
              if (ended) _buildResult(round) else _buildKeyboard(round),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard(GameRound round) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: letters.split('').map((letter) {
        final used = round.guessedLetters.contains(letter);
        return SizedBox(
          width: 43,
          height: 43,
          child: FilledButton(
            onPressed: used ? null : () => round.guess(letter),
            style: FilledButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(letter),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResult(GameRound round) {
    final won = round.status == GameStatus.won;
    return Column(
      children: [
        Text(won ? 'Você venceu!' : 'Fim de jogo: você perdeu.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: won ? Colors.green.shade800 : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
            'Resposta: ${round.answer.text}\n'
            'Erros: ${round.errors}\n'
            'Dica usada: ${round.hintUsed ? 'sim' : 'não'}',
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            FilledButton(
                onPressed: widget.onNewRound,
                child: const Text('Nova partida')),
            TextButton(
                onPressed: widget.onChooseOther,
                child: const Text('Trocar opções')),
          ],
        ),
      ],
    );
  }

  bool _isLetter(String character) =>
      RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ]$').hasMatch(character);
}

class HangmanPainter extends CustomPainter {
  HangmanPainter(this.errors);

  final int errors;

  @override
  void paint(Canvas canvas, Size size) {
    final wood = Paint()
      ..color = const Color(0xFF654321)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final person = Paint()
      ..color = const Color(0xFFB3261E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final left = size.width * 0.28;
    const top = 14.0;
    final bottom = size.height - 12;
    canvas.drawLine(Offset(left, bottom), Offset(left + 90, bottom), wood);
    canvas.drawLine(Offset(left + 45, bottom), Offset(left + 45, top), wood);
    canvas.drawLine(Offset(left + 45, top), Offset(left + 120, top), wood);
    canvas.drawLine(
        Offset(left + 120, top), Offset(left + 120, top + 22), wood);

    final head = Offset(left + 120, top + 40);
    if (errors >= 1) {
      canvas.drawCircle(head, 18, person);
    }
    if (errors >= 2) {
      canvas.drawLine(
          Offset(head.dx, head.dy + 18), Offset(head.dx, head.dy + 72), person);
    }
    if (errors >= 3) {
      canvas.drawLine(Offset(head.dx, head.dy + 32),
          Offset(head.dx - 25, head.dy + 55), person);
    }
    if (errors >= 4) {
      canvas.drawLine(Offset(head.dx, head.dy + 32),
          Offset(head.dx + 25, head.dy + 55), person);
    }
    if (errors >= 5) {
      canvas.drawLine(Offset(head.dx, head.dy + 72),
          Offset(head.dx - 23, head.dy + 105), person);
    }
    if (errors >= 6) {
      canvas.drawLine(Offset(head.dx, head.dy + 72),
          Offset(head.dx + 23, head.dy + 105), person);
    }
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) =>
      errors != oldDelegate.errors;
}
