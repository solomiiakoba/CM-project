import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'settings_language_picker.dart';
import 'settings_row.dart';

class SettingsLanguageTile extends StatelessWidget {
  final String currentLanguageCode;
  final ValueChanged<String?> onLanguageChanged;
  final String title;
  final String subtitle;

  const SettingsLanguageTile({
    super.key,
    required this.currentLanguageCode,
    required this.onLanguageChanged,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: Icons.language_rounded,
      iconColor: MNColors.secondary,
      title: title,
      subtitle: subtitle,
      trailing: SettingsLanguagePicker(
        value: currentLanguageCode,
        onChanged: onLanguageChanged,
      ),
    );
  }
}
