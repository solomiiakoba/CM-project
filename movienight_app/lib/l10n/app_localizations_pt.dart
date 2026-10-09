// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'MovieNight';

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
  String get createSessionSubtitle => 'Configura a tua Movie Night';

  @override
  String get createSessionDesc =>
      'Personaliza a sessão antes de convidar o teu grupo.';

  @override
  String get createSessionPresetFriday => 'Sexta de Cinema';

  @override
  String get createSessionPresetHorror => 'Noite de Terror';

  @override
  String get createSessionPresetSciFi => 'Maratona Sci-Fi';

  @override
  String get createSessionPresetComedy => 'Comédia com Amigos';

  @override
  String get howItWorksTitle => 'Como funciona a sessão';

  @override
  String get howItWorksStep1Title => 'Gera o Código QR';

  @override
  String get howItWorksStep1Desc =>
      'Apresenta o código no ecrã seguinte para os amigos entrarem.';

  @override
  String get howItWorksStep2Title => 'Rede Local Bluetooth';

  @override
  String get howItWorksStep2Desc =>
      'Conexão direta sem necessidade de internet ou servidores.';

  @override
  String get howItWorksStep3Title => 'Votação e Consenso';

  @override
  String get howItWorksStep3Desc =>
      'Todos votam nos seus telemóveis e o vencedor é apurado.';

  @override
  String get howItWorksHostBadge =>
      'O teu telemóvel será o anfitrião da rede local';

  @override
  String get createSessionLabel => 'Nome da sessão';

  @override
  String get createSessionHint => 'Ex.: Sexta de Cinema';

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
  String get lobbyStartVoting => 'Escolher filmes';

  @override
  String get lobbyVotingReady => 'Votação pronta para começar.';

  @override
  String get filtersTitle => 'Filtros de filmes';

  @override
  String get filtersSubtitle =>
      'Personaliza as sugestões de filmes para esta noite.';

  @override
  String get filtersGenres => 'Géneros';

  @override
  String get filtersGenresHint => 'Seleciona um ou mais géneros';

  @override
  String get filtersYearRange => 'Ano de lançamento';

  @override
  String get filtersYearFrom => 'De';

  @override
  String get filtersYearTo => 'Até';

  @override
  String get filtersMaxDuration => 'Duração máxima';

  @override
  String filtersMaxDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get filtersMaxDurationAny => 'Qualquer duração';

  @override
  String get filtersMinRating => 'Avaliação mínima';

  @override
  String get filtersPlatforms => 'Plataformas de streaming';

  @override
  String get filtersPlatformsHint => 'Seleciona uma ou mais plataformas';

  @override
  String get filtersReset => 'Limpar filtros';

  @override
  String get filtersApply => 'Carregar filmes';

  @override
  String filtersActiveCount(int count) {
    return '$count filtro(s) ativo(s)';
  }

  @override
  String get moviesTitle => 'Sugestões de filmes';

  @override
  String get moviesSubtitle =>
      'Estes filmes correspondem aos teus filtros. Vota nos teus favoritos!';

  @override
  String get moviesEmpty =>
      'Nenhum filme corresponde a estes filtros. Tenta alargar os critérios.';

  @override
  String get moviesLoading => 'A carregar filmes...';

  @override
  String get moviesError => 'Não foi possível carregar os filmes.';

  @override
  String get moviesRetry => 'Tentar novamente';

  @override
  String get moviesStartVoting => 'Iniciar votação';

  @override
  String moviesCount(int count) {
    return '$count filme(s)';
  }

  @override
  String get movieRating => 'Avaliação';

  @override
  String movieDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String movieYear(int year) {
    return '$year';
  }

  @override
  String get votingTitle => 'Votar';

  @override
  String get votingTiltRight => 'Inclina para a direita para gostar';

  @override
  String get votingTiltLeft => 'Inclina para a esquerda para saltar';

  @override
  String votingProgress(int current, int total) {
    return '$current de $total';
  }

  @override
  String get votingLike => 'Gosto';

  @override
  String get votingSkip => 'Saltar';

  @override
  String get votingFinished => 'Votaste em todos os filmes!';

  @override
  String get votingGoToResults => 'Ver resultados';

  @override
  String get votingHint => 'Inclina o telemóvel para votar';

  @override
  String get resultsTitle => 'Resultados';

  @override
  String get resultsSubtitle => 'Os favoritos desta noite!';

  @override
  String get resultsWinner => 'Vencedor';

  @override
  String resultsLikes(int count) {
    return '$count gosto(s)';
  }

  @override
  String get resultsNoVotes => 'Sem votos ainda.';

  @override
  String get resultsNewSession => 'Nova sessão';
}
