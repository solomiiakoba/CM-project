import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/core/bluetooth/movie_night_ble_client.dart';
import 'package:movienight_app/core/bluetooth/movie_night_peripheral_service.dart';
import 'package:movienight_app/features/movies/domain/movie.dart';
import 'package:movienight_app/features/voting/domain/entities/vote.dart';
import 'package:movienight_app/features/voting/domain/entities/voting_session.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

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
    final movieMap = {for (final m in widget.movies) m.id: m};
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
              // ── AppBar ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          colors: [
                            MNColors.primaryLight,
                            MNColors.secondary
                          ],
                        ).createShader(b),
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

              // ── Conteúdo ───────────────────────────────────────────────
              Expanded(
                child: ranked.isEmpty
                    ? Center(
                        child: Text(
                          l10n.resultsNoVotes,
                          style: TextStyle(
                              color: cs.onSurfaceVariant),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        itemCount: ranked.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final movie = ranked[index];
                          final likes = likesByMovie[movie.id] ?? 0;

                          if (index == 0) {
                            return _WinnerBanner(
                                movie: movie, likes: likes, l10n: l10n);
                          }
                          return _RankingRow(
                            position: index + 1,
                            movie: movie,
                            likes: likes,
                            maxLikes: likesByMovie[ranked.first.id] ?? 1,
                          );
                        },
                      ),
              ),

              // ── Botão nova sessão ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context)
                      .popUntil((r) => r.isFirst),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_rounded,
                            color: cs.primary, size: 20),
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

// ─────────────────────────────────────────────────────────────────────────────
// Banner do vencedor
// ─────────────────────────────────────────────────────────────────────────────

class _WinnerBanner extends StatelessWidget {
  final Movie movie;
  final int likes;
  final AppLocalizations l10n;

  const _WinnerBanner({
    required this.movie,
    required this.likes,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF1E0B3E),
                  Color(0xFF0C1E3E),
                ]
              : const [
                  Color(0xFF4C1D95),
                  Color(0xFF1E3A8A),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MNColors.primary.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: MNColors.primary.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label "VENCEDOR"
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded,
                    color: Color(0xFFFBBF24), size: 18),
                const SizedBox(width: 8),
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [
                      Color(0xFFFBBF24),
                      Color(0xFFF59E0B),
                    ],
                  ).createShader(b),
                  child: Text(
                    l10n.resultsWinner.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster
                Container(
                  width: 95,
                  height: 130,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: movie.posterPath != null &&
                          movie.posterPath!.startsWith('http')
                      ? Image.network(movie.posterPath!,
                          fit: BoxFit.cover)
                      : Icon(Icons.movie_rounded,
                          size: 48, color: cs.onPrimaryContainer),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movie.releaseYear}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Likes badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7C3AED),
                              Color(0xFF0891B2)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.favorite_rounded,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              l10n.resultsLikes(likes),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Géneros
                      Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: movie.genres.take(3).map((g) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              g,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Linha de ranking
// ─────────────────────────────────────────────────────────────────────────────

class _RankingRow extends StatelessWidget {
  final int position;
  final Movie movie;
  final int likes;
  final int maxLikes;

  const _RankingRow({
    required this.position,
    required this.movie,
    required this.likes,
    required this.maxLikes,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          // Posição
          SizedBox(
            width: 30,
            child: Text(
              '#$position',
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Mini poster
          Container(
            width: 44,
            height: 58,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: movie.posterPath != null &&
                    movie.posterPath!.startsWith('http')
                ? Image.network(movie.posterPath!, fit: BoxFit.cover)
                : Icon(Icons.movie_outlined,
                    color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 12),

          // Título e ano
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${movie.releaseYear}',
                  style: TextStyle(
                      color: cs.onSurfaceVariant, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Likes + barra
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite_rounded,
                      color: Color(0xFFEF4444), size: 13),
                  const SizedBox(width: 4),
                  Text(
                    l10n.resultsLikes(likes),
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: maxLikes > 0 ? likes / maxLikes : 0,
                    minHeight: 5,
                    backgroundColor: cs.outlineVariant,
                    valueColor: AlwaysStoppedAnimation(
                        cs.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
