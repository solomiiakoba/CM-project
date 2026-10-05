import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/features/movies/presentation/providers/movies_provider.dart';

/// Secção de visualização das plataformas de streaming em Portugal onde o filme se encontra disponível.
class MovieStreamingProvidersSection extends ConsumerWidget {
  final String movieId;
  final List<String> initialPlatforms;

  const MovieStreamingProvidersSection({
    super.key,
    required this.movieId,
    required this.initialPlatforms,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providersAsync = ref.watch(movieWatchProvidersProvider(movieId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Disponível em (Portugal):',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        providersAsync.when(
          loading: () => initialPlatforms.isNotEmpty
              ? _buildChips(context, initialPlatforms)
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'A carregar plataformas...',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
          error: (_, _) => _buildChips(
            context,
            initialPlatforms.isNotEmpty
                ? initialPlatforms
                : const ['Não especificado'],
          ),
          data: (providers) {
            final list =
                providers.isNotEmpty ? providers : initialPlatforms;
            if (list.isEmpty) {
              return const Text(
                'Sem streaming por subscrição ativo em Portugal.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              );
            }
            return _buildChips(context, list);
          },
        ),
      ],
    );
  }

  Widget _buildChips(BuildContext context, List<String> platforms) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: platforms.map<Widget>((p) {
        return Chip(
          avatar: const Icon(Icons.play_circle_outline, size: 16),
          label: Text(p),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.zero,
          labelStyle: Theme.of(context).textTheme.labelSmall,
        );
      }).toList(),
    );
  }
}
