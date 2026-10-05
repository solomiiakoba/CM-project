import 'package:flutter/material.dart';

import 'package:movienight_app/l10n/app_localizations.dart';

/// Ecrã de carregamento para a listagem de filmes.
class MoviesLoadingView extends StatelessWidget {
  const MoviesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.moviesLoading),
        ],
      ),
    );
  }
}

/// Ecrã de erro para a listagem de filmes com opção de repetição.
class MoviesErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const MoviesErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(l10n.moviesError, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.moviesRetry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ecrã exibido quando nenhum filme corresponde aos filtros definidos.
class MoviesEmptyView extends StatelessWidget {
  final VoidCallback onAdjustFilters;

  const MoviesEmptyView({
    super.key,
    required this.onAdjustFilters,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie_outlined, size: 64),
            const SizedBox(height: 16),
            Text(l10n.moviesEmpty, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onAdjustFilters,
              icon: const Icon(Icons.tune),
              label: Text(l10n.filtersReset),
            ),
          ],
        ),
      ),
    );
  }
}
