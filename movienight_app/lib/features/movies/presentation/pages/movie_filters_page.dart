import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/domain/movie_filters.dart';
import 'package:movienight_app/features/movies/presentation/providers/movies_provider.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'package:movienight_app/shared/widgets/particle_background.dart';

import 'movies_list_page.dart';

class MovieFiltersPage extends ConsumerStatefulWidget {
  final String sessionId;

  const MovieFiltersPage({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<MovieFiltersPage> createState() => _MovieFiltersPageState();
}

class _MovieFiltersPageState extends ConsumerState<MovieFiltersPage> {
  late Set<String> _selectedGenres;
  late Set<String> _selectedPlatforms;
  late double _minRating;
  int? _minYear;
  int? _maxYear;
  int? _maxDurationMinutes;

  final _minYearController = TextEditingController();
  final _maxYearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final current = ref.read(movieFiltersProvider);
    _selectedGenres = Set.from(current.genres);
    _selectedPlatforms = Set.from(current.streamingPlatforms);
    _minRating = current.minRating;
    _minYear = current.minYear;
    _maxYear = current.maxYear;
    _maxDurationMinutes = current.maxDurationMinutes;
    if (_minYear != null) _minYearController.text = _minYear.toString();
    if (_maxYear != null) _maxYearController.text = _maxYear.toString();
  }

  @override
  void dispose() {
    _minYearController.dispose();
    _maxYearController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = MovieFilters(
      genres: _selectedGenres.toList(),
      streamingPlatforms: _selectedPlatforms.toList(),
      minRating: _minRating,
      minYear: _minYear,
      maxYear: _maxYear,
      maxDurationMinutes: _maxDurationMinutes,
    );
    ref.read(movieFiltersProvider.notifier).update(filters);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoviesListPage(sessionId: widget.sessionId),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedGenres = {};
      _selectedPlatforms = {};
      _minRating = 0.0;
      _minYear = null;
      _maxYear = null;
      _maxDurationMinutes = null;
      _minYearController.clear();
      _maxYearController.clear();
    });
    ref.read(movieFiltersProvider.notifier).reset();
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedGenres.isNotEmpty) count++;
    if (_selectedPlatforms.isNotEmpty) count++;
    if (_minRating > 0.0) count++;
    if (_minYear != null) count++;
    if (_maxYear != null) count++;
    if (_maxDurationMinutes != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final genresAsync = ref.watch(availableGenresProvider);
    final platformsAsync = ref.watch(availablePlatformsProvider);
    final activeCount = _activeFilterCount;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ParticleBackground(
        particleCount: 25,
        child: SafeArea(
          child: Column(
            children: [
              // ── AppBar ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: cs.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        l10n.filtersTitle,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (activeCount > 0)
                      TextButton(
                        onPressed: _resetFilters,
                        style: TextButton.styleFrom(
                            foregroundColor: MNColors.primary),
                        child: Text(l10n.filtersReset),
                      ),
                  ],
                ),
              ),

              // ── Scrollable content ────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    Text(
                      l10n.filtersSubtitle,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),

                    if (activeCount > 0) ...[
                      const SizedBox(height: 10),
                      _ActiveFiltersBadge(count: activeCount, l10n: l10n),
                    ],

                    const SizedBox(height: 28),

                    // ── Genres ────────────────────────────────────────────
                    _SectionHeader(title: l10n.filtersGenres),
                    const SizedBox(height: 10),
                    genresAsync.when(
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              color: MNColors.primary)),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (genres) => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: genres.map((genre) {
                          final sel = _selectedGenres.contains(genre);
                          return _FilterChip(
                            label: genre,
                            selected: sel,
                            isDark: isDark,
                            onTap: () => setState(() => sel
                                ? _selectedGenres.remove(genre)
                                : _selectedGenres.add(genre)),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Year range ────────────────────────────────────────
                    _SectionHeader(title: l10n.filtersYearRange),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minYearController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: cs.onSurface),
                            decoration: InputDecoration(
                              labelText: l10n.filtersYearFrom,
                              isDense: true,
                            ),
                            onChanged: (v) =>
                                setState(() => _minYear = int.tryParse(v)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _maxYearController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: cs.onSurface),
                            decoration: InputDecoration(
                              labelText: l10n.filtersYearTo,
                              isDense: true,
                            ),
                            onChanged: (v) =>
                                setState(() => _maxYear = int.tryParse(v)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Max duration ──────────────────────────────────────
                    _SectionHeader(
                      title: l10n.filtersMaxDuration,
                      trailing: _maxDurationMinutes != null
                          ? l10n.filtersMaxDurationMinutes(
                              _maxDurationMinutes!)
                          : l10n.filtersMaxDurationAny,
                    ),
                    Slider(
                      value: (_maxDurationMinutes ?? 240).toDouble(),
                      min: 60,
                      max: 240,
                      divisions: 18,
                      label: _maxDurationMinutes != null
                          ? l10n.filtersMaxDurationMinutes(
                              _maxDurationMinutes!)
                          : l10n.filtersMaxDurationAny,
                      onChanged: (v) => setState(() =>
                          _maxDurationMinutes = v >= 240 ? null : v.round()),
                    ),

                    const SizedBox(height: 20),

                    // ── Min rating ────────────────────────────────────────
                    _SectionHeader(
                      title: l10n.filtersMinRating,
                      trailing: _minRating > 0
                          ? '${_minRating.toStringAsFixed(1)} ⭐'
                          : '—',
                    ),
                    Slider(
                      value: _minRating,
                      min: 0.0,
                      max: 9.0,
                      divisions: 18,
                      label: _minRating.toStringAsFixed(1),
                      onChanged: (v) => setState(() => _minRating = v),
                    ),

                    const SizedBox(height: 28),

                    // ── Platforms ─────────────────────────────────────────
                    _SectionHeader(title: l10n.filtersPlatforms),
                    const SizedBox(height: 10),
                    platformsAsync.when(
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              color: MNColors.primary)),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (platforms) => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: platforms.map((p) {
                          final sel = _selectedPlatforms.contains(p);
                          return _FilterChip(
                            label: p,
                            selected: sel,
                            isDark: isDark,
                            onTap: () => setState(() => sel
                                ? _selectedPlatforms.remove(p)
                                : _selectedPlatforms.add(p)),
                            icon: Icons.play_circle_outline_rounded,
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // ── Apply button ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: GestureDetector(
                  onTap: _applyFilters,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [MNColors.primary, MNColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: MNColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.movie_filter_rounded,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          l10n.filtersApply,
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
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              color: MNColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter chip
// ─────────────────────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Selected: always use primaryContainer + primaryLight text (works both modes)
    // Unselected: use theme surface + onSurfaceVariant text
    final bgColor = selected
        ? (isDark ? MNColors.primaryContainer : const Color(0xFFEDE9FE))
        : cs.surfaceContainerHighest;
    final borderColor = selected
        ? MNColors.primary
        : cs.outlineVariant;
    final textColor = selected ? MNColors.primaryLight : cs.onSurface;
    final iconColor = selected ? MNColors.primaryLight : cs.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: icon != null ? 10 : 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: iconColor),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Active filters badge
// ─────────────────────────────────────────────────────────────────────────────

class _ActiveFiltersBadge extends StatelessWidget {
  final int count;
  final AppLocalizations l10n;
  const _ActiveFiltersBadge({required this.count, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MNColors.primary.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_list_rounded,
              size: 14, color: MNColors.primaryLight),
          const SizedBox(width: 6),
          Text(
            l10n.filtersActiveCount(count),
            style: const TextStyle(
              color: MNColors.primaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
