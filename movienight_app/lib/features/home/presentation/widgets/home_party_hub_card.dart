import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/widgets/glass_container.dart';

/// Cartão compacto do Party Hub com ações rápidas para Criar Sessão e Entrar com QR Code,
/// totalmente adaptável ao modo claro e escuro.
class HomePartyHubCard extends StatelessWidget {
  final VoidCallback onCreateSession;
  final VoidCallback onJoinSession;
  final VoidCallback onBluetoothTest;

  const HomePartyHubCard({
    super.key,
    required this.onCreateSession,
    required this.onJoinSession,
    required this.onBluetoothTest,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.groups_rounded,
                    color: isDark ? MNColors.primaryLight : MNColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sessão em Grupo',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onBluetoothTest,
                tooltip: 'Diagnóstico Bluetooth',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.bluetooth_searching_rounded,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // ── Botão Criar Sessão (Host) ─────────────────────────
              Expanded(
                child: _buildActionButton(
                  onTap: onCreateSession,
                  title: 'Criar Sessão',
                  subtitle: 'Modo Anfitrião',
                  icon: Icons.add_circle_outline_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ── Botão Entrar com QR (Peer) ────────────────────────
              Expanded(
                child: _buildActionButton(
                  onTap: onJoinSession,
                  title: 'Entrar com QR',
                  subtitle: 'Ler Código',
                  icon: Icons.qr_code_scanner_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0891B2), Color(0xFF0E7490)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
