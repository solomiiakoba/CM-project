import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../core/bluetooth/bluetooth_peripheral_test_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../movies/presentation/widgets/movie_details_bottom_sheet.dart';
import '../../../session/presentation/pages/create_session_page.dart';
import '../../../session/presentation/pages/scan_session_page.dart';
import '../providers/home_feed_provider.dart';
import '../widgets/home_logo_header.dart';
import '../widgets/home_party_hub_card.dart';
import '../widgets/home_spotlight_parallax_card.dart';
import '../widgets/home_trending_section.dart';

/// Ecrã inicial dinâmico da aplicação, combinando filme em destaque com efeito parallax,
/// hub de sessão para grupos e carrossel de tendências da TMDb API.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final feedState = ref.watch(homeFeedProvider);
    final feed = feedState.feed;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.read(homeFeedProvider.notifier).refresh(),
        color: isDark ? MNColors.primaryLight : MNColors.primary,
        backgroundColor: cs.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cabeçalho com Logótipo e Título ────────────────────
              HomeLogoHeader(
                title: l10n.appTitle,
                description: l10n.appDescription,
              ),
              const SizedBox(height: 24),

              // ── Filme do Dia (Spotlight Parallax) ──────────────────
              if (feed.hasSpotlight)
                HomeSpotlightParallaxCard(
                  movie: feed.spotlightMovie!,
                  onTap: () => MovieDetailsBottomSheet.show(
                    context,
                    feed.spotlightMovie!,
                  ),
                )
              else if (feedState.isLoading)
                _buildLoadingCard(context)
              else
                const SizedBox.shrink(),

              const SizedBox(height: 20),

              // ── Party Hub (Ações Rápidas de Sessão) ────────────────
              HomePartyHubCard(
                onCreateSession: () => Navigator.push(
                  context,
                  _fadeRoute(const CreateSessionPage()),
                ),
                onJoinSession: () => Navigator.push(
                  context,
                  _fadeRoute(const ScanSessionPage()),
                ),
                onBluetoothTest: () => Navigator.push(
                  context,
                  _fadeRoute(const BluetoothPeripheralTestPage()),
                ),
              ),

              const SizedBox(height: 24),

              // ── Carrossel Horizontal: Em Tendência ─────────────────
              if (feed.hasTrending)
                HomeTrendingSection(
                  movies: feed.trendingMovies,
                  onMovieTap: (movie) => MovieDetailsBottomSheet.show(
                    context,
                    movie,
                  ),
                )
              else if (feedState.isLoading)
                _buildLoadingTrending(context),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: cs.primary,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildLoadingTrending(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: Center(
        child: CircularProgressIndicator(
          color: cs.secondary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  PageRoute _fadeRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 320),
      );
}
