import 'package:flutter/material.dart';

import 'package:movienight_app/features/movies/presentation/widgets/filter_chip_item.dart';
import 'package:movienight_app/features/movies/presentation/widgets/filter_section_header.dart';

/// Secção para selecionar a quantidade limite de filmes do catálogo a pesquisar.
class ResultsCountSection extends StatelessWidget {
  final int selectedCount;
  final ValueChanged<int> onCountSelected;
  final List<int> options;

  const ResultsCountSection({
    super.key,
    required this.selectedCount,
    required this.onCountSelected,
    this.options = const [10, 20, 30, 50, 75],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(
          title: 'Quantidade de filmes',
          trailing: '$selectedCount filmes',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((count) {
            final isSelected = selectedCount == count;
            return FilterChipItem(
              label: '$count filmes',
              selected: isSelected,
              onTap: () => onCountSelected(count),
              icon: Icons.movie_outlined,
            );
          }).toList(),
        ),
      ],
    );
  }
}
