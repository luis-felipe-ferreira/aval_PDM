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

### Em um celular Android conectado por USB (Windows PowerShell)

1. Instale o Flutter e o Android Studio com as ferramentas do Android SDK. No Android Studio, abra **SDK Manager > SDK Tools > Show Package Details** e instale o NDK `28.2.13676358` se ainda não estiver instalado.
2. No celular, ative as **Opções do desenvolvedor** e a **Depuração USB**. Conecte-o ao computador com um cabo USB que permita transferência de dados e desbloqueie a tela.
3. Abra o PowerShell nesta pasta do projeto e baixe as dependências:

   ```powershell
   flutter pub get
   ```

4. Confira se o Flutter reconheceu o celular:

   ```powershell
   flutter devices
   ```

5. Na primeira conexão, aceite no celular a autorização de depuração USB. Use o identificador mostrado em `flutter devices` para iniciar o app (o identificador pode ser diferente em cada computador):

   ```powershell
   flutter run -d IDENTIFICADOR_DO_CELULAR
   ```

   Por exemplo: `flutter run -d VOU8YXJZ8LC6VS79`.

A primeira compilação pode demorar, pois o Flutter baixa e prepara componentes do Android. Mantenha o celular desbloqueado e aceite qualquer solicitação de instalação que aparecer. Se o terminal mostrar `INSTALL_FAILED_USER_RESTRICTED`, o APK foi compilado, mas a instalação foi bloqueada ou cancelada no celular. Desbloqueie-o, aceite a solicitação e rode novamente o comando. Se necessário, confira se **Depuração USB** e, quando disponível, **Instalar via USB** estão ativadas nas Opções do desenvolvedor.

Para executar em outro dispositivo disponível, use `flutter devices` para ver as opções e rode `flutter run -d IDENTIFICADOR`. Se a pasta `android/` não estiver presente, gere os arquivos da plataforma com `flutter create . --platforms=android` antes de baixar as dependências.

## Organização

- `lib/main.dart`: modelos, carregamento do JSON, regras da partida, estatísticas e telas.
- `assets/data/hangman_entries.json`: respostas, categorias, níveis e dicas.


