import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'MovieNight 🎬'**
  String get appTitle;

  /// No description provided for @appDescription.
  ///
  /// In pt, this message translates to:
  /// **'Escolhe um filme com os teus amigos.'**
  String get appDescription;

  /// No description provided for @newSession.
  ///
  /// In pt, this message translates to:
  /// **'Nova sessão'**
  String get newSession;

  /// No description provided for @joinSession.
  ///
  /// In pt, this message translates to:
  /// **'Entrar numa sessão'**
  String get joinSession;

  /// No description provided for @bluetoothPeripheral.
  ///
  /// In pt, this message translates to:
  /// **'Bluetooth Peripheral'**
  String get bluetoothPeripheral;

  /// No description provided for @home.
  ///
  /// In pt, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In pt, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeDescription.
  ///
  /// In pt, this message translates to:
  /// **'Alternar entre modo claro e escuro'**
  String get darkModeDescription;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In pt, this message translates to:
  /// **'Escolhe o idioma da aplicação'**
  String get languageDescription;

  /// No description provided for @aboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acerca da MovieNight'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In pt, this message translates to:
  /// **'Versão 1.0.0'**
  String get aboutVersion;

  /// No description provided for @createSessionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova sessão'**
  String get createSessionTitle;

  /// No description provided for @createSessionSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Vamos começar uma Movie Night 🍿'**
  String get createSessionSubtitle;

  /// No description provided for @createSessionDesc.
  ///
  /// In pt, this message translates to:
  /// **'Define algumas informações para a sessão.'**
  String get createSessionDesc;

  /// No description provided for @createSessionLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome da sessão'**
  String get createSessionLabel;

  /// No description provided for @createSessionHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Friday Movie Night'**
  String get createSessionHint;

  /// No description provided for @createSessionButton.
  ///
  /// In pt, this message translates to:
  /// **'Criar sessão'**
  String get createSessionButton;

  /// No description provided for @createSessionEmptyName.
  ///
  /// In pt, this message translates to:
  /// **'Introduz um nome para a sessão.'**
  String get createSessionEmptyName;

  /// No description provided for @scanSessionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar numa sessão'**
  String get scanSessionTitle;

  /// No description provided for @scanSessionInstruction.
  ///
  /// In pt, this message translates to:
  /// **'Aponta a câmara para o QR Code da sessão'**
  String get scanSessionInstruction;

  /// No description provided for @scanSessionError.
  ///
  /// In pt, this message translates to:
  /// **'QR Code inválido.'**
  String get scanSessionError;

  /// No description provided for @lobbyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Lobby'**
  String get lobbyTitle;

  /// No description provided for @lobbySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Junta os teus amigos à Movie Night.'**
  String get lobbySubtitle;

  /// No description provided for @lobbySessionCode.
  ///
  /// In pt, this message translates to:
  /// **'Código da sessão'**
  String get lobbySessionCode;

  /// No description provided for @lobbyBluetoothPreparing.
  ///
  /// In pt, this message translates to:
  /// **'A preparar Bluetooth...'**
  String get lobbyBluetoothPreparing;

  /// No description provided for @lobbyBluetoothAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Sessão disponível por Bluetooth'**
  String get lobbyBluetoothAvailable;

  /// No description provided for @lobbyBluetoothError.
  ///
  /// In pt, this message translates to:
  /// **'Erro no Bluetooth'**
  String get lobbyBluetoothError;

  /// No description provided for @lobbyNewParticipant.
  ///
  /// In pt, this message translates to:
  /// **'Novo participante entrou.'**
  String get lobbyNewParticipant;

  /// No description provided for @lobbyParticipants.
  ///
  /// In pt, this message translates to:
  /// **'Participantes'**
  String get lobbyParticipants;

  /// No description provided for @lobbyYou.
  ///
  /// In pt, this message translates to:
  /// **'Tu'**
  String get lobbyYou;

  /// No description provided for @lobbyOrganizer.
  ///
  /// In pt, this message translates to:
  /// **'Organizador'**
  String get lobbyOrganizer;

  /// No description provided for @lobbyParticipant.
  ///
  /// In pt, this message translates to:
  /// **'Participante'**
  String get lobbyParticipant;

  /// No description provided for @lobbyWaiting.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando amigos...'**
  String get lobbyWaiting;

  /// No description provided for @lobbyStartVoting.
  ///
  /// In pt, this message translates to:
  /// **'Escolher filmes'**
  String get lobbyStartVoting;

  /// No description provided for @lobbyVotingReady.
  ///
  /// In pt, this message translates to:
  /// **'Votação pronta para começar.'**
  String get lobbyVotingReady;

  /// No description provided for @filtersTitle.
  ///
  /// In pt, this message translates to:
  /// **'Filtros de filmes'**
  String get filtersTitle;

  /// No description provided for @filtersSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Personaliza as sugestões de filmes para esta noite.'**
  String get filtersSubtitle;

  /// No description provided for @filtersGenres.
  ///
  /// In pt, this message translates to:
  /// **'Géneros'**
  String get filtersGenres;

  /// No description provided for @filtersGenresHint.
  ///
  /// In pt, this message translates to:
  /// **'Seleciona um ou mais géneros'**
  String get filtersGenresHint;

  /// No description provided for @filtersYearRange.
  ///
  /// In pt, this message translates to:
  /// **'Ano de lançamento'**
  String get filtersYearRange;

  /// No description provided for @filtersYearFrom.
  ///
  /// In pt, this message translates to:
  /// **'De'**
  String get filtersYearFrom;

  /// No description provided for @filtersYearTo.
  ///
  /// In pt, this message translates to:
  /// **'Até'**
  String get filtersYearTo;

  /// No description provided for @filtersMaxDuration.
  ///
  /// In pt, this message translates to:
  /// **'Duração máxima'**
  String get filtersMaxDuration;

  /// No description provided for @filtersMaxDurationMinutes.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} min'**
  String filtersMaxDurationMinutes(int minutes);

  /// No description provided for @filtersMaxDurationAny.
  ///
  /// In pt, this message translates to:
  /// **'Qualquer duração'**
  String get filtersMaxDurationAny;

  /// No description provided for @filtersMinRating.
  ///
  /// In pt, this message translates to:
  /// **'Avaliação mínima'**
  String get filtersMinRating;

  /// No description provided for @filtersPlatforms.
  ///
  /// In pt, this message translates to:
  /// **'Plataformas de streaming'**
  String get filtersPlatforms;

  /// No description provided for @filtersPlatformsHint.
  ///
  /// In pt, this message translates to:
  /// **'Seleciona uma ou mais plataformas'**
  String get filtersPlatformsHint;

  /// No description provided for @filtersReset.
  ///
  /// In pt, this message translates to:
  /// **'Limpar filtros'**
  String get filtersReset;

  /// No description provided for @filtersApply.
  ///
  /// In pt, this message translates to:
  /// **'Carregar filmes'**
  String get filtersApply;

  /// No description provided for @filtersActiveCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} filtro(s) ativo(s)'**
  String filtersActiveCount(int count);

  /// No description provided for @moviesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sugestões de filmes'**
  String get moviesTitle;

  /// No description provided for @moviesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Estes filmes correspondem aos teus filtros. Vota nos teus favoritos!'**
  String get moviesSubtitle;

  /// No description provided for @moviesEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum filme corresponde a estes filtros. Tenta alargar os critérios.'**
  String get moviesEmpty;

  /// No description provided for @moviesLoading.
  ///
  /// In pt, this message translates to:
  /// **'A carregar filmes...'**
  String get moviesLoading;

  /// No description provided for @moviesError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar os filmes.'**
  String get moviesError;

  /// No description provided for @moviesRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get moviesRetry;

  /// No description provided for @moviesStartVoting.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar votação'**
  String get moviesStartVoting;

  /// No description provided for @moviesCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} filme(s)'**
  String moviesCount(int count);

  /// No description provided for @movieRating.
  ///
  /// In pt, this message translates to:
  /// **'Avaliação'**
  String get movieRating;

  /// No description provided for @movieDuration.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} min'**
  String movieDuration(int minutes);

  /// No description provided for @movieYear.
  ///
  /// In pt, this message translates to:
  /// **'{year}'**
  String movieYear(int year);

  /// No description provided for @votingTitle.
  ///
  /// In pt, this message translates to:
  /// **'Votar'**
  String get votingTitle;

  /// No description provided for @votingTiltRight.
  ///
  /// In pt, this message translates to:
  /// **'Inclina para a direita para gostar'**
  String get votingTiltRight;

  /// No description provided for @votingTiltLeft.
  ///
  /// In pt, this message translates to:
  /// **'Inclina para a esquerda para saltar'**
  String get votingTiltLeft;

  /// No description provided for @votingProgress.
  ///
  /// In pt, this message translates to:
  /// **'{current} de {total}'**
  String votingProgress(int current, int total);

  /// No description provided for @votingLike.
  ///
  /// In pt, this message translates to:
  /// **'Gosto'**
  String get votingLike;

  /// No description provided for @votingSkip.
  ///
  /// In pt, this message translates to:
  /// **'Saltar'**
  String get votingSkip;

  /// No description provided for @votingFinished.
  ///
  /// In pt, this message translates to:
  /// **'Votaste em todos os filmes!'**
  String get votingFinished;

  /// No description provided for @votingGoToResults.
  ///
  /// In pt, this message translates to:
  /// **'Ver resultados'**
  String get votingGoToResults;

  /// No description provided for @votingHint.
  ///
  /// In pt, this message translates to:
  /// **'Inclina o telemóvel para votar'**
  String get votingHint;

  /// No description provided for @resultsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Resultados'**
  String get resultsTitle;

  /// No description provided for @resultsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Os favoritos desta noite!'**
  String get resultsSubtitle;

  /// No description provided for @resultsWinner.
  ///
  /// In pt, this message translates to:
  /// **'Vencedor 🏆'**
  String get resultsWinner;

  /// No description provided for @resultsLikes.
  ///
  /// In pt, this message translates to:
  /// **'{count} gosto(s)'**
  String resultsLikes(int count);

  /// No description provided for @resultsNoVotes.
  ///
  /// In pt, this message translates to:
  /// **'Sem votos ainda.'**
  String get resultsNoVotes;

  /// No description provided for @resultsNewSession.
  ///
  /// In pt, this message translates to:
  /// **'Nova sessão'**
  String get resultsNewSession;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
