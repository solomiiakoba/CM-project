import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

import '../features/session/presentation/pages/create_session_page.dart';
import '../features/session/presentation/pages/scan_session_page.dart';
import '../core/bluetooth/bluetooth_peripheral_test_page.dart';
import '../shared/widgets/particle_background.dart';

import 'theme.dart';
import 'main_navigation_page.dart';
import '../shared/providers/theme_provider.dart';
import '../shared/providers/locale_provider.dart';

class MovieNightApp extends ConsumerWidget {
  const MovieNightApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'MovieNight',
      debugShowCheckedModeBanner: false,
      // Disable animated theme transitions — prevents TextStyle lerp crashes
      // when switching between light and dark themes (inherit mismatch).
      themeAnimationDuration: Duration.zero,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
      ],
      locale: locale,
      theme: MovieNightTheme.light,
      darkTheme: MovieNightTheme.dark,
      themeMode: themeMode,
      home: const MainNavigationPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomePage — ecrã principal com partículas e botões premium
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 56),

            // ── Logo / título ─────────────────────────────────────────
            _LogoHeader(l10n: l10n),

            const Spacer(),

            // ── Botão principal: Criar sessão ─────────────────────────
            _PrimaryActionButton(
              icon: Icons.add_circle_outline_rounded,
              label: l10n.newSession,
              gradient: const LinearGradient(
                colors: [MNColors.primary, MNColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Navigator.push(
                context,
                _fadeRoute(const CreateSessionPage()),
              ),
            ),

            const SizedBox(height: 16),

            // ── Botão secundário: Entrar na sessão ────────────────────
            _PrimaryActionButton(
              icon: Icons.qr_code_scanner_rounded,
              label: l10n.joinSession,
              gradient: const LinearGradient(
                colors: [MNColors.secondary, MNColors.secondaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Navigator.push(
                context,
                _fadeRoute(const ScanSessionPage()),
              ),
            ),

            const SizedBox(height: 32),

            // ── Link discreto de teste BT ─────────────────────────────
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  _fadeRoute(const BluetoothPeripheralTestPage()),
                ),
                icon: const Icon(Icons.bluetooth, size: 16),
                label: Text(
                  l10n.bluetoothPeripheral,
                  style: const TextStyle(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  PageRoute _fadeRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo + header
// ─────────────────────────────────────────────────────────────────────────────

class _LogoHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _LogoHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ícone com glow
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [MNColors.primary, MNColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: MNColors.primary.withOpacity(0.5),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.movie_filter_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),

        const SizedBox(height: 28),

        // Título
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [MNColors.primaryLight, MNColors.secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            l10n.appTitle,
            style: const TextStyle(
              color: Colors.white, // masked pelo shader
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          l10n.appDescription,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Botão de ação grande com gradiente
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 62,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MNColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
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
    );
  }
}
