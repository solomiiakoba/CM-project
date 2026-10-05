import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class SettingsLanguagePicker extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const SettingsLanguagePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        style: const TextStyle(
          color: MNColors.primaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: MNColors.primaryLight,
          size: 18,
        ),
        onChanged: onChanged,
        items: const [
          DropdownMenuItem(
            value: 'pt',
            child: Text('PT (Português)'),
          ),
          DropdownMenuItem(
            value: 'en',
            child: Text('EN (English)'),
          ),
        ],
      ),
    );
  }
}
