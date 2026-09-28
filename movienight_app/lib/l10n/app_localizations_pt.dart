// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'MovieNight 🎬';

  @override
  String get appDescription => 'Escolhe um filme com os teus amigos.';

  @override
  String get newSession => 'Nova sessão';

  @override
  String get joinSession => 'Entrar numa sessão';

  @override
  String get bluetoothPeripheral => 'Bluetooth Peripheral';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDescription => 'Alternar entre modo claro e escuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription => 'Escolhe o idioma da aplicação';

  @override
  String get aboutTitle => 'Acerca da MovieNight';

  @override
  String get aboutVersion => 'Versão 1.0.0';

  @override
  String get createSessionTitle => 'Nova sessão';

  @override
  String get createSessionSubtitle => 'Vamos começar uma Movie Night 🍿';

  @override
  String get createSessionDesc => 'Define algumas informações para a sessão.';

  @override
  String get createSessionLabel => 'Nome da sessão';

  @override
  String get createSessionHint => 'Ex.: Friday Movie Night';

  @override
  String get createSessionButton => 'Criar sessão';

  @override
  String get createSessionEmptyName => 'Introduz um nome para a sessão.';

  @override
  String get scanSessionTitle => 'Entrar numa sessão';

  @override
  String get scanSessionInstruction =>
      'Aponta a câmara para o QR Code da sessão';

  @override
  String get scanSessionError => 'QR Code inválido.';

  @override
  String get lobbyTitle => 'Lobby';

  @override
  String get lobbySubtitle => 'Junta os teus amigos à Movie Night.';

  @override
  String get lobbySessionCode => 'Código da sessão';

  @override
  String get lobbyBluetoothPreparing => 'A preparar Bluetooth...';

  @override
  String get lobbyBluetoothAvailable => 'Sessão disponível por Bluetooth';

  @override
  String get lobbyBluetoothError => 'Erro no Bluetooth';

  @override
  String get lobbyNewParticipant => 'Novo participante entrou.';

  @override
  String get lobbyParticipants => 'Participantes';

  @override
  String get lobbyYou => 'Tu';

  @override
  String get lobbyOrganizer => 'Organizador';

  @override
  String get lobbyParticipant => 'Participante';

  @override
  String get lobbyWaiting => 'Aguardando amigos...';

  @override
  String get lobbyStartVoting => 'Começar votação';

  @override
  String get lobbyVotingReady => 'Votação pronta para começar.';
}
