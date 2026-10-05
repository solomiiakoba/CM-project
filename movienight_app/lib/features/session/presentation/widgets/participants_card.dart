import 'package:flutter/material.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/session/domain/entities/session.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

/// Card que lista os membros conetados à sessão em tempo real, distinguindo o organizador dos pares.
class ParticipantsCard extends StatelessWidget {
  final Session session;
  final int participantCount;

  const ParticipantsCard({
    super.key,
    required this.session,
    required this.participantCount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          // Cabeçalho da secção com contador
          Row(
            children: [
              const Icon(
                Icons.people_rounded,
                color: MNColors.primaryLight,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.lobbyParticipants,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [MNColors.primary, MNColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$participantCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: cs.outlineVariant, height: 1),
          const SizedBox(height: 16),

          // Organizador
          ParticipantTile(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFBBF24),
            name: l10n.lobbyYou,
            subtitle: l10n.lobbyOrganizer,
          ),

          if (session.participantIds.isEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 8),
                Icon(
                  Icons.hourglass_empty_rounded,
                  size: 14,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.lobbyWaiting,
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],

          for (final pid in session.participantIds) ...[
            const SizedBox(height: 8),
            ParticipantTile(
              icon: Icons.person_rounded,
              iconColor: MNColors.primaryLight,
              name: l10n.lobbyParticipant,
              subtitle: pid,
            ),
          ],
        ],
      ),
    );
  }
}

/// Item visual individual de um participante conectado à sessão.
class ParticipantTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String name;
  final String subtitle;

  const ParticipantTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
