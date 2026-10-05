import 'package:flutter/material.dart';

import '../../../../core/bluetooth/bluetooth_peripheral_test_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../session/presentation/pages/create_session_page.dart';
import '../../../session/presentation/pages/scan_session_page.dart';
import '../widgets/home_actions_section.dart';
import '../widgets/home_logo_header.dart';

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
            HomeLogoHeader(
              title: l10n.appTitle,
              description: l10n.appDescription,
            ),
            const Spacer(),
            HomeActionsSection(
              createSessionLabel: l10n.newSession,
              joinSessionLabel: l10n.joinSession,
              bluetoothTestLabel: l10n.bluetoothPeripheral,
              onCreateSession: () => Navigator.push(
                context,
                _fadeRoute(const CreateSessionPage()),
              ),
              onJoinSession: () => Navigator.push(
                context,
                _fadeRoute(const ScanSessionPage()),
              ),
              onBluetoothTest: () => Navigator.push(
                context,
                _fadeRoute(const BluetoothPeripheralTestPage()),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  PageRoute _fadeRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      );
}
