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

    return Scaffold(
      backgroundColor: MNColors.background,
      // Permite que o layout encolha quando o teclado aparece
      resizeToAvoidBottomInset: true,
      body: ParticleBackground(
        particleCount: 30,
        child: SafeArea(
          child: SingleChildScrollView(
            // Sobe o conteúdo quando o teclado aparece
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ConstrainedBox(
              // Garante que o conteúdo ocupa pelo menos a altura do ecrã
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── AppBar ──────────────────────────────────────────────
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: MNColors.onBackground),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Ícone ───────────────────────────────────────────────
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

                    // ── Título ──────────────────────────────────────────────
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
                      style: const TextStyle(
                        color: MNColors.onSurfaceVar,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Campo de nome ───────────────────────────────────────
                    Text(
                      l10n.createSessionLabel,
                      style: const TextStyle(
                        color: MNColors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      autofocus: true,
                      style: const TextStyle(
                        color: MNColors.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.createSessionHint,
                        prefixIcon: const Icon(Icons.movie_filter_rounded,
                            color: MNColors.primaryLight, size: 20),
                      ),
                      onSubmitted: (_) => _createSession(),
                    ),

                    // Empurra o botão para baixo (substitui Spacer)
                    const Spacer(),
                    const SizedBox(height: 32),

                    // ── Botão criar ─────────────────────────────────────────
                    GestureDetector(
                      onTap: _loading ? null : _createSession,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [MNColors.primary, MNColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
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
