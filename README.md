# Jogo da Forca

## Integrantes

- Luis Felipe Ferreira Martins
- Adonias Pereira dos Santos Terceiro

## Descrição

Jogo da Forca para Android, feito com Flutter e Dart. As respostas e dicas são lidas de um arquivo JSON incluído no aplicativo. O jogo funciona offline.

## Funcionalidades

- Seleção dinâmica: aparecem apenas categorias e dificuldades existentes no JSON.
- Sorteio sem repetir a mesma resposta na sessão e na mesma combinação.
- Teclado com letras, comparação sem acentos e exibição de respostas compostas.
- Forca com seis etapas, dica por rodada, resultado e estatísticas da sessão.
- Tela “Sobre” com a identificação da equipe.

## Tecnologias

- Flutter e Dart.
- JSON local em `assets/data/hangman_entries.json`.

## Dependências

- Flutter SDK (com Dart SDK incluído).
- `flutter_lints`, usado para análise estática do código.
- O app não usa pacotes externos em tempo de execução.

## Como executar

1. Instale o Flutter e configure um emulador Android ou conecte um dispositivo.
2. Na pasta do projeto, execute `flutter pub get`.
3. Inicie um emulador ou conecte um dispositivo e execute `flutter run`.

Se a pasta `android/` não estiver presente, gere os arquivos da plataforma com `flutter create . --platforms=android` antes de baixar as dependências.

## Organização

- `lib/main.dart`: modelos, carregamento do JSON, regras da partida, estatísticas e telas.
- `assets/data/hangman_entries.json`: respostas, categorias, níveis e dicas.


