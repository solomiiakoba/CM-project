import 'package:flutter/material.dart';

import 'package:movienight_app/features/movies/presentation/widgets/filter_section_header.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

/// Secção de filtragem por intervalo de anos de lançamento do filme.
class YearRangeFilterSection extends StatelessWidget {
  final TextEditingController minYearController;
  final TextEditingController maxYearController;
  final ValueChanged<String>? onMinYearChanged;
  final ValueChanged<String>? onMaxYearChanged;

  const YearRangeFilterSection({
    super.key,
    required this.minYearController,
    required this.maxYearController,
    this.onMinYearChanged,
    this.onMaxYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(title: l10n.filtersYearRange),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minYearController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: cs.onSurface),
                decoration: InputDecoration(
                  labelText: l10n.filtersYearFrom,
                  isDense: true,
                ),
                onChanged: onMinYearChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: maxYearController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: cs.onSurface),
                decoration: InputDecoration(
                  labelText: l10n.filtersYearTo,
                  isDense: true,
                ),
                onChanged: onMaxYearChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
