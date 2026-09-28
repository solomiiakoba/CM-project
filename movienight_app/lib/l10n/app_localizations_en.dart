// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MovieNight 🎬';

  @override
  String get appDescription => 'Choose a movie with your friends.';

  @override
  String get newSession => 'New session';

  @override
  String get joinSession => 'Join a session';

  @override
  String get bluetoothPeripheral => 'Bluetooth Peripheral';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDescription => 'Toggle between light and dark theme';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'Choose the application language';

  @override
  String get aboutTitle => 'About MovieNight';

  @override
  String get aboutVersion => 'Version 1.0.0';

  @override
  String get createSessionTitle => 'New session';

  @override
  String get createSessionSubtitle => 'Let\'s start a Movie Night 🍿';

  @override
  String get createSessionDesc => 'Set some information for the session.';

  @override
  String get createSessionLabel => 'Session Name';

  @override
  String get createSessionHint => 'Ex.: Friday Movie Night';

  @override
  String get createSessionButton => 'Create session';

  @override
  String get createSessionEmptyName => 'Please enter a session name.';

  @override
  String get scanSessionTitle => 'Join a session';

  @override
  String get scanSessionInstruction =>
      'Point the camera at the session QR Code';

  @override
  String get scanSessionError => 'Invalid QR Code.';

  @override
  String get lobbyTitle => 'Lobby';

  @override
  String get lobbySubtitle => 'Join your friends to the Movie Night.';

  @override
  String get lobbySessionCode => 'Session code';

  @override
  String get lobbyBluetoothPreparing => 'Preparing Bluetooth...';

  @override
  String get lobbyBluetoothAvailable => 'Session available via Bluetooth';

  @override
  String get lobbyBluetoothError => 'Bluetooth error';

  @override
  String get lobbyNewParticipant => 'New participant joined.';

  @override
  String get lobbyParticipants => 'Participants';

  @override
  String get lobbyYou => 'You';

  @override
  String get lobbyOrganizer => 'Organizer';

  @override
  String get lobbyParticipant => 'Participant';

  @override
  String get lobbyWaiting => 'Waiting for friends...';

  @override
  String get lobbyStartVoting => 'Start voting';

  @override
  String get lobbyVotingReady => 'Voting ready to start.';
}
