import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movienight_app/l10n/app_localizations.dart';

import 'app.dart';
import 'theme.dart';
import '../features/settings/presentation/pages/settings_page.dart';

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
      backgroundColor: MNColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // extendBody removido — evita overflow por baixo da nav bar
      bottomNavigationBar: _GlassNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        destinations: [
          _NavDest(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: l10n.home,
          ),
          _NavDest(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Barra de navegação com efeito glassmorphism
// ─────────────────────────────────────────────────────────────────────────────

class _NavDest {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavDest({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavDest> destinations;

  const _GlassNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: MNColors.surface.withOpacity(0.85),
            border: const Border(
              top: BorderSide(color: MNColors.outlineVar, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: List.generate(destinations.length, (i) {
                  final dest = destinations[i];
                  final selected = i == currentIndex;
                  return Expanded(
                    child: _NavItem(
                      icon: dest.icon,
                      activeIcon: dest.activeIcon,
                      label: dest.label,
                      selected: selected,
                      onTap: () => onTap(i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? MNColors.primaryContainer.withOpacity(0.8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                selected ? activeIcon : icon,
                color: selected ? MNColors.primaryLight : MNColors.onSurfaceVar,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? MNColors.primaryLight
                    : MNColors.onSurfaceVar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
