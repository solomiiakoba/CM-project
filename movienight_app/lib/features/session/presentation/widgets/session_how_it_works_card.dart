import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/glass_container.dart';

/// Cartão informativo com o design glassmorphic escuro que explica
/// o fluxo da sessão ad-hoc de votação.
class SessionHowItWorksCard extends StatelessWidget {
  const SessionHowItWorksCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: isDark ? MNColors.primaryLight : MNColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.howItWorksTitle,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStepRow(
            context,
            icon: Icons.qr_code_2_rounded,
            title: l10n.howItWorksStep1Title,
            description: l10n.howItWorksStep1Desc,
          ),
          const SizedBox(height: 12),
          _buildStepRow(
            context,
            icon: Icons.bluetooth_connected_rounded,
            title: l10n.howItWorksStep2Title,
            description: l10n.howItWorksStep2Desc,
          ),
          const SizedBox(height: 12),
          _buildStepRow(
            context,
            icon: Icons.how_to_vote_rounded,
            title: l10n.howItWorksStep3Title,
            description: l10n.howItWorksStep3Desc,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E2436)
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? Colors.white10 : cs.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sensors_rounded,
                  size: 15,
                  color: isDark ? MNColors.secondary : MNColors.secondaryDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.howItWorksHostBadge,
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: (isDark ? MNColors.primary : MNColors.primaryDark)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 17,
            color: isDark ? MNColors.primaryLight : MNColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
