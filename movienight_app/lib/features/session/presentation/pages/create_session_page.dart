import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/session/presentation/providers/session_controller.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

import 'session_lobby_page.dart';

class CreateSessionPage extends ConsumerStatefulWidget {
  const CreateSessionPage({super.key});

  @override
  ConsumerState<CreateSessionPage> createState() =>
      _CreateSessionPageState();
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
      final session =
          await ref.read(sessionControllerProvider).createSession(name: name);

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
      // Use the theme's scaffold background so ParticleBackground sits correctly
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
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: cs.onSurface,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Icon ────────────────────────────────────────────────
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [MNColors.primary, MNColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: MNColors.primary.withOpacity(0.45),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add_circle_outline_rounded,
                          color: Colors.white, size: 28),
                    ),

                    const SizedBox(height: 20),

                    // ── Title ───────────────────────────────────────────────
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [MNColors.primaryLight, MNColors.secondary],
                      ).createShader(b),
                      child: Text(
                        l10n.createSessionSubtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      l10n.createSessionDesc,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Session name label ──────────────────────────────────
                    Text(
                      l10n.createSessionLabel,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Text field ──────────────────────────────────────────
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
                        // Override fill colour per-theme so it's legible
                        filled: true,
                        fillColor: isDark
                            ? MNColors.surfaceVar
                            : Colors.white,
                        prefixIcon: Icon(
                          Icons.movie_filter_rounded,
                          color: MNColors.primaryLight,
                          size: 20,
                        ),
                        // Override borders with solid colours
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? MNColors.outlineVar
                                : const Color(0xFFCBD5E1),
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

                    // ── Create button ───────────────────────────────────────
                    GestureDetector(
                      onTap: _loading ? null : _createSession,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: _loading
                              ? null
                              : const LinearGradient(
                                  colors: [MNColors.primary, MNColors.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: _loading ? cs.surfaceContainerHighest : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _loading
                              ? []
                              : [
                                  BoxShadow(
                                    color: MNColors.primary.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: _loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.rocket_launch_rounded,
                                        color: Colors.white, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      l10n.createSessionButton,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
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
