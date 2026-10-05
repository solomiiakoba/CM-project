import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/app/theme.dart';
import 'package:movienight_app/features/movies/domain/entities/movie_filters.dart';
import 'package:movienight_app/features/movies/presentation/providers/movies_provider.dart';
import 'package:movienight_app/features/movies/presentation/widgets/active_filters_badge.dart';
import 'package:movienight_app/features/movies/presentation/widgets/gradient_action_button.dart';
import 'package:movienight_app/features/movies/presentation/widgets/movie_page_header.dart';
import 'package:movienight_app/features/movies/presentation/widgets/sections/genre_filter_section.dart';
import 'package:movienight_app/features/movies/presentation/widgets/sections/platform_filter_section.dart';
import 'package:movienight_app/features/movies/presentation/widgets/sections/results_count_section.dart';
import 'package:movienight_app/features/movies/presentation/widgets/sections/slider_filter_section.dart';
import 'package:movienight_app/features/movies/presentation/widgets/sections/year_range_filter_section.dart';
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
  int _maxResults = 20;

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
    _maxResults = current.maxResults;
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
      maxResults: _maxResults,
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
      _maxResults = 20;
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
    if (_maxResults != 20) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final activeCount = _activeFilterCount;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ParticleBackground(
        particleCount: 25,
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ───────────────────────────────────────────────────
              MoviePageHeader(
                title: l10n.filtersTitle,
                trailing: activeCount > 0
                    ? TextButton(
                        onPressed: _resetFilters,
                        style: TextButton.styleFrom(
                          foregroundColor: MNColors.primary,
                        ),
                        child: Text(l10n.filtersReset),
                      )
                    : null,
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
                      ActiveFiltersBadge(
                        label: l10n.filtersActiveCount(activeCount),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // ── Genres ────────────────────────────────────────────
                    GenreFilterSection(
                      selectedGenres: _selectedGenres,
                      onGenreToggled: (genre) {
                        setState(() {
                          if (_selectedGenres.contains(genre)) {
                            _selectedGenres.remove(genre);
                          } else {
                            _selectedGenres.add(genre);
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── Year range ────────────────────────────────────────
                    YearRangeFilterSection(
                      minYearController: _minYearController,
                      maxYearController: _maxYearController,
                      onMinYearChanged: (v) =>
                          setState(() => _minYear = int.tryParse(v)),
                      onMaxYearChanged: (v) =>
                          setState(() => _maxYear = int.tryParse(v)),
                    ),

                    const SizedBox(height: 28),

                    // ── Max duration ──────────────────────────────────────
                    SliderFilterSection(
                      title: l10n.filtersMaxDuration,
                      trailing: _maxDurationMinutes != null
                          ? l10n.filtersMaxDurationMinutes(_maxDurationMinutes!)
                          : l10n.filtersMaxDurationAny,
                      value: (_maxDurationMinutes ?? 240).toDouble(),
                      min: 60,
                      max: 240,
                      divisions: 18,
                      label: _maxDurationMinutes != null
                          ? l10n.filtersMaxDurationMinutes(_maxDurationMinutes!)
                          : l10n.filtersMaxDurationAny,
                      onChanged: (v) => setState(() =>
                          _maxDurationMinutes = v >= 240 ? null : v.round()),
                    ),

                    const SizedBox(height: 20),

                    // ── Min rating ────────────────────────────────────────
                    SliderFilterSection(
                      title: l10n.filtersMinRating,
                      trailing: _minRating > 0
                          ? '${_minRating.toStringAsFixed(1)} ⭐'
                          : '—',
                      value: _minRating,
                      min: 0.0,
                      max: 9.0,
                      divisions: 18,
                      label: _minRating.toStringAsFixed(1),
                      onChanged: (v) => setState(() => _minRating = v),
                    ),

                    const SizedBox(height: 28),

                    // ── Platforms ─────────────────────────────────────────
                    PlatformFilterSection(
                      selectedPlatforms: _selectedPlatforms,
                      onPlatformToggled: (p) {
                        setState(() {
                          if (_selectedPlatforms.contains(p)) {
                            _selectedPlatforms.remove(p);
                          } else {
                            _selectedPlatforms.add(p);
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── Quantidade de filmes ──────────────────────────────
                    ResultsCountSection(
                      selectedCount: _maxResults,
                      onCountSelected: (count) =>
                          setState(() => _maxResults = count),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // ── Apply button ──────────────────────────────────────────────
              GradientActionButton(
                label: l10n.filtersApply,
                icon: Icons.movie_filter_rounded,
                onTap: _applyFilters,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
