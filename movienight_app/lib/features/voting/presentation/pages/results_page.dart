import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/bluetooth/movie_night_ble_client.dart';
import '../../../../core/bluetooth/movie_night_peripheral_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/particle_background.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/entities/vote.dart';
import '../../domain/entities/voting_session.dart';
import '../../domain/usecases/get_ar_trophy_config_usecase.dart';
import 'ar_winner_page.dart';
import '../widgets/results_empty_view.dart';
import '../widgets/results_ranking_row.dart';
import '../widgets/results_winner_banner.dart';

class ResultsPage extends StatefulWidget {
  final VotingSession votingSession;
  final List<Movie> movies;
  final MovieNightBleClient? bleClient;

  const ResultsPage({
    super.key,
    required this.votingSession,
    required this.movies,
    this.bleClient,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late VotingSession _votingSession;
  final MovieNightPeripheralService _peripheralService =
      MovieNightPeripheralService();
  StreamSubscription<Map<String, dynamic>>? _clientSubscription;
  StreamSubscription<Uint8List>? _peripheralSubscription;

  @override
  void initState() {
    super.initState();
    _votingSession = widget.votingSession;

    if (widget.bleClient != null) {
      _clientSubscription = widget.bleClient!.messages.listen(_handleMessage);
    } else {
      _peripheralSubscription =
          _peripheralService.receivedData.listen(_handlePeripheralData);
    }
  }

  void _handlePeripheralData(Uint8List data) {
    try {
      final decoded = jsonDecode(utf8.decode(data, allowMalformed: true));
      if (decoded is Map) {
        _handleMessage(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (message['type'] != 'vote_cast' ||
        message['sessionId']?.toString() != _votingSession.sessionId) {
      return;
    }

    final rawVote = message['vote'];
    if (rawVote is! Map) return;

    try {
      final vote = Vote.fromJson(Map<String, dynamic>.from(rawVote));
      final updated = _votingSession.addVote(vote);
      if (mounted && updated.votes.length != _votingSession.votes.length) {
        setState(() => _votingSession = updated);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _clientSubscription?.cancel();
    _peripheralSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final movieMap = {for (final movie in widget.movies) movie.id: movie};
    final ranked = _votingSession.rankedMovieIds
        .map((id) => movieMap[id])
        .whereType<Movie>()
        .toList();
    final likesByMovie = _votingSession.likesByMovie;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ParticleBackground(
        particleCount: 35,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            MNColors.primaryLight,
                            MNColors.secondary,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          l10n.resultsTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ranked.isEmpty
                    ? ResultsEmptyView(message: l10n.resultsNoVotes)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        itemCount: ranked.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final movie = ranked[index];
                          final likes = likesByMovie[movie.id] ?? 0;

                          if (index == 0) {
                            return ResultsWinnerBanner(
                              movie: movie,
                              likes: likes,
                              winnerLabel: l10n.resultsWinner,
                              likesFormatted: l10n.resultsLikes(likes),
                              onLaunchAr: () {
                                final totalParticipants = _votingSession.votes
                                    .map((v) => v.participantId)
                                    .toSet()
                                    .length;
                                const useCase = GetArTrophyConfigUseCase();
                                final config = useCase.execute(
                                  winnerMovie: movie,
                                  affirmativeVotes: likes,
                                  totalParticipants: totalParticipants > 0
                                      ? totalParticipants
                                      : 1,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ArWinnerPage(config: config),
                                  ),
                                );
                              },
                            );
                          }
                          return ResultsRankingRow(
                            position: index + 1,
                            movie: movie,
                            likes: likes,
                            maxLikes: likesByMovie[ranked.first.id] ?? 1,
                            likesFormatted: l10n.resultsLikes(likes),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    borderRadius: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_rounded, color: cs.primary, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          l10n.resultsNewSession,
                          style: TextStyle(
                            color: cs.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
