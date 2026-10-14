# Jogo da Forca

## Integrantes

- Luis Felipe Ferreira Martins
- Adonias (completar com o nome completo)

## Descrição

Jogo da Forca para Android, feito com Flutter e Dart. As respostas e dicas são lidas de um arquivo JSON incluído no aplicativo. O jogo funciona offline.

## Funcionalidades

- Seleção de categoria e dificuldade.
- Sorteio sem repetir a mesma resposta na sessão e na mesma combinação.
- Teclado com letras, comparação sem acentos e exibição de respostas compostas.
- Forca com seis etapas, dica por rodada, resultado e estatísticas da sessão.
- Tela “Sobre” com a identificação da equipe.

## Tecnologias

- Flutter e Dart.
- JSON local em `assets/data/hangman_entries.json`.

## Como executar

1. Instale o Flutter e configure um emulador Android ou conecte um dispositivo.
2. Na pasta do projeto, gere os arquivos da plataforma Android com `flutter create --platforms=android .`.
3. Execute `flutter pub get` e depois `flutter run`.

## Organização

- `lib/main.dart`: modelos, carregamento do JSON, regras da partida, estatísticas e telas.
- `assets/data/hangman_entries.json`: respostas, categorias, níveis e dicas.

## Como explicar o código

1. `AnswerCategory` e `Difficulty` são enums: limitam as categorias e dificuldades aos valores do enunciado.
2. `Answer.fromJson` transforma cada item do JSON em um objeto. `AnswerRepository` abre o arquivo local do app.
3. `GameRound` cuida de uma rodada: letras escolhidas, erros, dica, acentos e condição de vitória ou derrota.
4. `GameSession` sorteia sem repetir respostas e soma as estatísticas das rodadas concluídas.
5. `HomePage` deixa escolher as opções. `GamePage` mostra a palavra, o teclado e o resultado.
6. `HangmanPainter` desenha a forca e adiciona uma parte do boneco por erro.

Para explicar uma tentativa: o botão chama `guess`; o jogo compara a letra sem acento; se estiver errada, soma um erro; em seguida a tela atualiza o desenho e verifica se a rodada terminou.
