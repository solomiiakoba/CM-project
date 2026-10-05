import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/session/presentation/providers/session_controller.dart';
import 'package:movienight_app/features/session/presentation/widgets/session_hero_header.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: ParticleBackground(
        particleCount: 30,
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Back button ─────────────────────────────────────────
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: cs.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(height: 16),

                    // ── Hero Header ─────────────────────────────────────────
                    SessionHeroHeader(
                      icon: Icons.add_circle_outline_rounded,
                      title: l10n.createSessionSubtitle,
                      subtitle: l10n.createSessionDesc,
                    ),

                    const SizedBox(height: 40),

                    // ── Session Name Field ──────────────────────────────────
                    Text(
                      l10n.createSessionLabel,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      autofocus: true,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.createSessionHint,
                        filled: true,
                        fillColor: isDark ? MNColors.surfaceVar : Colors.white,
                        prefixIcon: const Icon(
                          Icons.movie_filter_rounded,
                          color: MNColors.primaryLight,
                          size: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? MNColors.outlineVar : const Color(0xFFCBD5E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: MNColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _createSession(),
                    ),

                    const Spacer(),
                    const SizedBox(height: 32),

                    // ── Create Action Button ────────────────────────────────
                    GradientActionButton(
                      label: l10n.createSessionButton,
                      icon: Icons.rocket_launch_rounded,
                      isLoading: _loading,
                      onTap: _createSession,
                      padding: const EdgeInsets.only(bottom: 32),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
