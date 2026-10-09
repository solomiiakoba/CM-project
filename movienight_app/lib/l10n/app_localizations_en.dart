// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MovieNight';

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
  String get createSessionSubtitle => 'Set up your Movie Night';

  @override
  String get createSessionDesc =>
      'Customize the session before inviting your group.';

  @override
  String get createSessionPresetFriday => 'Friday Movie Night';

  @override
  String get createSessionPresetHorror => 'Horror Night';

  @override
  String get createSessionPresetSciFi => 'Sci-Fi Marathon';

  @override
  String get createSessionPresetComedy => 'Comedy with Friends';

  @override
  String get howItWorksTitle => 'How it works';

  @override
  String get howItWorksStep1Title => 'Generate QR Code';

  @override
  String get howItWorksStep1Desc =>
      'Display the code on the next screen for friends to join.';

  @override
  String get howItWorksStep2Title => 'Local Bluetooth Mesh';

  @override
  String get howItWorksStep2Desc =>
      'Direct peer connection without internet or central servers.';

  @override
  String get howItWorksStep3Title => 'Voting and Consensus';

  @override
  String get howItWorksStep3Desc =>
      'Everyone votes on their phones to find the winning movie.';

  @override
  String get howItWorksHostBadge =>
      'Your phone will act as the local network host';

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
  String get lobbyStartVoting => 'Choose movies';

  @override
  String get lobbyVotingReady => 'Voting ready to start.';

  @override
  String get filtersTitle => 'Movie Filters';

  @override
  String get filtersSubtitle => 'Customise the film suggestions for tonight.';

  @override
  String get filtersGenres => 'Genres';

  @override
  String get filtersGenresHint => 'Select one or more genres';

  @override
  String get filtersYearRange => 'Release year';

  @override
  String get filtersYearFrom => 'From';

  @override
  String get filtersYearTo => 'To';

  @override
  String get filtersMaxDuration => 'Max duration';

  @override
  String filtersMaxDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get filtersMaxDurationAny => 'Any duration';

  @override
  String get filtersMinRating => 'Minimum rating';

  @override
  String get filtersPlatforms => 'Streaming platforms';

  @override
  String get filtersPlatformsHint => 'Select one or more platforms';

  @override
  String get filtersReset => 'Reset filters';

  @override
  String get filtersApply => 'Load movies';

  @override
  String filtersActiveCount(int count) {
    return '$count active filter(s)';
  }

  @override
  String get moviesTitle => 'Movie suggestions';

  @override
  String get moviesSubtitle =>
      'These films match your filters. Vote for your favourites!';

  @override
  String get moviesEmpty =>
      'No films match these filters. Try broadening the criteria.';

  @override
  String get moviesLoading => 'Loading films...';

  @override
  String get moviesError => 'Could not load films.';

  @override
  String get moviesRetry => 'Try again';

  @override
  String get moviesStartVoting => 'Start voting';

  @override
  String moviesCount(int count) {
    return '$count film(s)';
  }

  @override
  String get movieRating => 'Rating';

  @override
  String movieDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String movieYear(int year) {
    return '$year';
  }

  @override
  String get votingTitle => 'Vote';

  @override
  String get votingTiltRight => 'Tilt right to like';

  @override
  String get votingTiltLeft => 'Tilt left to skip';

  @override
  String votingProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get votingLike => 'Like';

  @override
  String get votingSkip => 'Skip';

  @override
  String get votingFinished => 'You\'ve voted on all films!';

  @override
  String get votingGoToResults => 'See results';

  @override
  String get votingHint => 'Tilt your phone to vote';

  @override
  String get resultsTitle => 'Results';

  @override
  String get resultsSubtitle => 'Here are tonight\'s top picks!';

  @override
  String get resultsWinner => 'Winner';

  @override
  String resultsLikes(int count) {
    return '$count like(s)';
  }

  @override
  String get resultsNoVotes => 'No votes yet.';

  @override
  String get resultsNewSession => 'New session';
}
