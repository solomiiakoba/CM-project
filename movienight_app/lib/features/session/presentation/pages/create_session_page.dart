import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/session/presentation/providers/session_controller.dart';
import 'package:movienight_app/features/session/presentation/widgets/session_how_it_works_card.dart';
import 'package:movienight_app/features/session/presentation/widgets/session_name_presets_row.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/glass_back_button.dart';
import 'package:movienight_app/shared/widgets/gradient_action_button.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

import 'session_lobby_page.dart';

/// Ecrã de criação de uma nova sessão de MovieNight pelo organizador.
class CreateSessionPage extends ConsumerStatefulWidget {
  const CreateSessionPage({super.key});

  @override
  ConsumerState<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends ConsumerState<CreateSessionPage> {
  final _nameController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSelectPreset(String preset) {
    setState(() {
      _nameController.text = preset;
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: preset.length),
      );
    });
  }

  Future<void> _createSession() async {
    final name = _nameController.text.trim();
    final l10n = AppLocalizations.of(context)!;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.createSessionEmptyName)),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final session = await ref.read(createSessionUseCaseProvider).execute(name: name);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SessionLobbyPage(session: session),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final presets = [
      l10n.createSessionPresetFriday,
      l10n.createSessionPresetHorror,
      l10n.createSessionPresetSciFi,
      l10n.createSessionPresetComedy,
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: ParticleBackground(
        particleCount: 30,
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Navigation Bar ──────────────────────────────
                Row(
                  children: [
                    GlassBackButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      l10n.createSessionTitle,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Título Cinematográfico Limpo ────────────────────
                ShaderMask(
                  shaderCallback: (b) => LinearGradient(
                    colors: isDark
                        ? const [MNColors.primaryLight, MNColors.secondary]
                        : const [Color(0xFF6D28D9), Color(0xFF0284C7)],
                  ).createShader(b),
                  child: Text(
                    l10n.createSessionSubtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.createSessionDesc,
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Campo: Nome da Sessão ───────────────────────────
                Text(
                  l10n.createSessionLabel,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.createSessionHint,
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF141724).withValues(alpha: 0.8)
                        : cs.surfaceContainerHighest.withValues(alpha: 0.55),
                    prefixIcon: Icon(
                      Icons.movie_filter_rounded,
                      color: isDark ? MNColors.primaryLight : MNColors.primary,
                      size: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white12 : cs.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark ? MNColors.primary : MNColors.primaryDark,
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _createSession(),
                ),

                const SizedBox(height: 12),

                // ── Atalhos Rápidos para Nome ───────────────────────
                SessionNamePresetsRow(
                  presets: presets,
                  onSelectPreset: _onSelectPreset,
                ),

                const SizedBox(height: 24),

                // ── Card Informativo "Como Funciona" ────────────────
                const SessionHowItWorksCard(),

                const SizedBox(height: 28),

                // ── Botão Primário: Criar Sessão ────────────────────
                GradientActionButton(
                  label: l10n.createSessionButton,
                  icon: Icons.rocket_launch_rounded,
                  isLoading: _loading,
                  onTap: _createSession,
                  padding: const EdgeInsets.only(bottom: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
