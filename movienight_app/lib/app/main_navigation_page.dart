import 'package:flutter/material.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/glass_nav_bar.dart';
import '../shared/widgets/particle_background.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    HomePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ParticleBackground(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: GlassNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavDestination(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: l10n.home,
          ),
          NavDestination(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
