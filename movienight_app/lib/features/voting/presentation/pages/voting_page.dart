import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/voting_providers.dart';
import '../widgets/movie_vote_card.dart';
import '../widgets/voting_action_buttons.dart';
import '../widgets/voting_finished_view.dart';
import '../widgets/voting_gesture_indicators.dart';
import '../widgets/voting_header.dart';
import '../widgets/voting_progress_bar.dart';
import 'results_page.dart';

class VotingPage extends ConsumerWidget {
  final VotingParams params;

  const VotingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(votingProvider(params));
    final l10n = AppLocalizations.of(context)!;

    if (state.isFinished && state.votingSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsPage(
              votingSession: state.votingSession!,
              movies: state.movies,
              bleClient: params.bleClient,
            ),
          ),
        );
      });
    }

    final bgColor = _backgroundFor(context, state.gesture);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: state.isFinished
            ? VotingFinishedView(
                title: l10n.votingFinished,
                buttonLabel: l10n.votingGoToResults,
                onResults: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultsPage(
                      votingSession: state.votingSession!,
                      movies: state.movies,
                      bleClient: params.bleClient,
                    ),
                  ),
                ),
              )
            : _VotingContent(params: params, state: state, l10n: l10n),
      ),
    );
  }

  Color _backgroundFor(BuildContext context, TiltGesture gesture) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (gesture) {
      case TiltGesture.right:
        return isDark ? const Color(0xFF0A1F0A) : const Color(0xFFE8F5E9);
      case TiltGesture.left:
        return isDark ? const Color(0xFF1F0A0A) : const Color(0xFFFFEBEE);
      case TiltGesture.none:
        return Theme.of(context).scaffoldBackgroundColor;
    }
  }
}

class _VotingContent extends ConsumerWidget {
  final VotingParams params;
  final VotingState state;
  final AppLocalizations l10n;

  const _VotingContent({
    required this.params,
    required this.state,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final movie = state.currentMovie;
    if (movie == null) return const SizedBox.shrink();

    final notifier = ref.read(votingProvider(params).notifier);

    final tiltFraction = (state.tiltX / 10.0).clamp(-1.0, 1.0);
    final rotation = tiltFraction * 0.25;
    final offsetX = tiltFraction * 40.0;

    return Column(
      children: [
        VotingHeader(
          title: l10n.votingTitle,
          current: state.progress + 1,
          total: state.total,
          onClose: () => Navigator.pop(context),
        ),
        VotingProgressBar(
          progress: state.progress,
          total: state.total,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (state.isAnimating) return;
                final velocity = details.primaryVelocity ?? 0;
                if (velocity > 300) {
                  notifier.voteByTap(true);
                } else if (velocity < -300) {
                  notifier.voteByTap(false);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                transform: Matrix4.identity()
                  ..setEntry(0, 3, offsetX)
                  ..rotateZ(rotation),
                transformAlignment: Alignment.bottomCenter,
                child: MovieVoteCard(
                  movie: movie,
                  gesture: state.gesture,
                ),
              ),
            ),
          ),
        ),
        VotingGestureIndicators(
          gesture: state.gesture,
          skipLabel: l10n.votingSkip,
          likeLabel: l10n.votingLike,
        ),
        VotingActionButtons(
          skipLabel: l10n.votingSkip,
          likeLabel: l10n.votingLike,
          isAnimating: state.isAnimating,
          onSkip: () => notifier.voteByTap(false),
          onLike: () => notifier.voteByTap(true),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            l10n.votingHint,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
