import 'package:flutter/material.dart';

import 'package:movienight_app/features/movies/presentation/widgets/filter_section_header.dart';

/// Secção reutilizável contendo cabeçalho e seletor Slider para valores numéricos.
class SliderFilterSection extends StatelessWidget {
  final String title;
  final String? trailing;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double> onChanged;

  const SliderFilterSection({
    super.key,
    required this.title,
    this.trailing,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(
          title: title,
          trailing: trailing,
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
