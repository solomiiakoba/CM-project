import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/presentation/providers/movies_provider.dart';
import 'package:movienight_app/features/movies/presentation/widgets/filter_chip_item.dart';
import 'package:movienight_app/features/movies/presentation/widgets/filter_section_header.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

/// Secção de seleção de plataformas de streaming suportadas com dados carregados via Riverpod.
class PlatformFilterSection extends ConsumerWidget {
  final Set<String> selectedPlatforms;
  final ValueChanged<String> onPlatformToggled;

  const PlatformFilterSection({
    super.key,
    required this.selectedPlatforms,
    required this.onPlatformToggled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final platformsAsync = ref.watch(availablePlatformsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(title: l10n.filtersPlatforms),
        const SizedBox(height: 10),
        platformsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: MNColors.primary),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (platforms) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: platforms.map((p) {
              final isSelected = selectedPlatforms.contains(p);
              return FilterChipItem(
                label: p,
                selected: isSelected,
                onTap: () => onPlatformToggled(p),
                icon: Icons.play_circle_outline_rounded,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
