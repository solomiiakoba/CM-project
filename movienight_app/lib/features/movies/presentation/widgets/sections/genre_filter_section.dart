import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/presentation/providers/movies_provider.dart';
import 'package:movienight_app/features/movies/presentation/widgets/filter_chip_item.dart';
import 'package:movienight_app/features/movies/presentation/widgets/filter_section_header.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

/// Secção de seleção de géneros de filmes com carregamento assíncrono via Riverpod.
class GenreFilterSection extends ConsumerWidget {
  final Set<String> selectedGenres;
  final ValueChanged<String> onGenreToggled;

  const GenreFilterSection({
    super.key,
    required this.selectedGenres,
    required this.onGenreToggled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final genresAsync = ref.watch(availableGenresProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(title: l10n.filtersGenres),
        const SizedBox(height: 10),
        genresAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: MNColors.primary),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (genres) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genres.map((genre) {
              final isSelected = selectedGenres.contains(genre);
              return FilterChipItem(
                label: genre,
                selected: isSelected,
                onTap: () => onGenreToggled(genre),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
