import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Paleta de cores MovieNight
// ─────────────────────────────────────────────────────────────────────────────

class MNColors {
  MNColors._();

  // Fundos
  static const background    = Color(0xFF0D0B1E); // roxo-preto
  static const surface       = Color(0xFF13102A); // superfície de cards
  static const surfaceVar    = Color(0xFF1C1836); // superfície elevada

  // Primária — violeta/roxo vivo
  static const primary       = Color(0xFF8B5CF6); // violet-500
  static const primaryLight  = Color(0xFFA78BFA); // violet-400
  static const primaryDark   = Color(0xFF6D28D9); // violet-700
  static const onPrimary     = Color(0xFFFFFFFF);

  // Secundária — ciano/azul
  static const secondary     = Color(0xFF06B6D4); // cyan-500
  static const secondaryDark = Color(0xFF0891B2); // cyan-600
  static const onSecondary   = Color(0xFFFFFFFF);

  // Contentor (chips, badges)
  static const primaryContainer    = Color(0xFF2E1065); // roxo muito escuro
  static const onPrimaryContainer  = Color(0xFFDDD6FE); // violeta pastel
  static const secondaryContainer  = Color(0xFF164E63); // ciano muito escuro
  static const onSecondaryContainer= Color(0xFFCFFAFE); // ciano pastel

  // Texto & ícones
  static const onBackground = Color(0xFFF1F0FF);
  static const onSurface    = Color(0xFFEDE9FE);
  static const onSurfaceVar = Color(0xFF9D8FBF); // texto subtil

  // Erro
  static const error   = Color(0xFFF87171);
  static const onError = Color(0xFF1A0000);

  // Outline & divisores
  static const outline     = Color(0xFF3730A3); // índigo escuro
  static const outlineVar  = Color(0xFF2D2555);

  // Gradientes utilitários
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient cardGradient = LinearGradient(
    colors: [surfaceVar, Color(0xFF110D2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tema
// ─────────────────────────────────────────────────────────────────────────────

class MovieNightTheme {
  MovieNightTheme._();

  // O app corre sempre em modo escuro com este tema,
  // mas mantemos o getter `light` para compatibilidade (aponta para dark).
  static ThemeData get light => dark;

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,

      primary:           MNColors.primary,
      onPrimary:         MNColors.onPrimary,
      primaryContainer:  MNColors.primaryContainer,
      onPrimaryContainer:MNColors.onPrimaryContainer,

      secondary:           MNColors.secondary,
      onSecondary:         MNColors.onSecondary,
      secondaryContainer:  MNColors.secondaryContainer,
      onSecondaryContainer:MNColors.onSecondaryContainer,

      tertiary:    Color(0xFFF472B6), // pink-400
      onTertiary:  Color(0xFF1A0020),

      error:   MNColors.error,
      onError: MNColors.onError,

      surface:          MNColors.surface,
      onSurface:        MNColors.onSurface,
      surfaceContainerHighest: MNColors.surfaceVar,
      onSurfaceVariant: MNColors.onSurfaceVar,

      outline:        MNColors.outline,
      outlineVariant: MNColors.outlineVar,

      shadow:         Color(0xFF000000),
      scrim:          Color(0xFF000000),
      inverseSurface:       Color(0xFFEDE9FE),
      onInverseSurface:     Color(0xFF1A0E2E),
      inversePrimary:       MNColors.primaryDark,
      surfaceTint:          MNColors.primary,
    ),

    // ── Scaffold / fundos ──────────────────────────────────────────────────
    scaffoldBackgroundColor: MNColors.background,

    // ── AppBar ─────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: MNColors.onBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: MNColors.onBackground,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      iconTheme: IconThemeData(color: MNColors.onBackground),
    ),

    // ── Cards ──────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: MNColors.surfaceVar,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: MNColors.outlineVar,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
    ),

    // ── Elevated button ────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return MNColors.outlineVar;
          }
          return MNColors.primary;
        }),
        foregroundColor: WidgetStateProperty.all(MNColors.onPrimary),
        overlayColor: WidgetStateProperty.all(
          MNColors.primaryLight.withOpacity(0.12),
        ),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ),
    ),

    // ── Outlined button ────────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(MNColors.primaryLight),
        side: WidgetStateProperty.all(
          const BorderSide(color: MNColors.primary, width: 1.5),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    ),

    // ── Text button ────────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(MNColors.primaryLight),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),

    // ── Input / TextField ──────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MNColors.surfaceVar,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MNColors.outlineVar),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MNColors.outlineVar),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: MNColors.primary, width: 2),
      ),
      labelStyle: const TextStyle(color: MNColors.onSurfaceVar),
      hintStyle:
          const TextStyle(color: MNColors.onSurfaceVar, fontSize: 14),
    ),

    // ── NavigationBar ──────────────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: MNColors.surface,
      indicatorColor: MNColors.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: MNColors.primaryLight, size: 24);
        }
        return const IconThemeData(color: MNColors.onSurfaceVar, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: MNColors.primaryLight,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          );
        }
        return const TextStyle(
          color: MNColors.onSurfaceVar,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        );
      }),
      elevation: 0,
    ),

    // ── Chip ───────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: MNColors.surfaceVar,
      selectedColor: MNColors.primaryContainer,
      disabledColor: MNColors.outlineVar,
      labelStyle: const TextStyle(
        color: MNColors.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      side: const BorderSide(color: MNColors.outlineVar),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    // ── Slider ─────────────────────────────────────────────────────────────
    sliderTheme: const SliderThemeData(
      activeTrackColor: MNColors.primary,
      inactiveTrackColor: MNColors.outlineVar,
      thumbColor: MNColors.primaryLight,
      overlayColor: Color(0x228B5CF6),
      valueIndicatorColor: MNColors.primaryDark,
      valueIndicatorTextStyle: TextStyle(color: Colors.white),
    ),

    // ── Divider ────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: MNColors.outlineVar,
      thickness: 1,
      space: 1,
    ),

    // ── Switch ─────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? MNColors.primary
              : MNColors.onSurfaceVar),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? MNColors.primaryContainer
              : MNColors.outlineVar),
    ),

    // ── Progress indicator ─────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MNColors.primary,
      linearTrackColor: MNColors.outlineVar,
    ),

    // ── SnackBar ───────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: MNColors.surfaceVar,
      contentTextStyle: const TextStyle(color: MNColors.onSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Bottom sheet ───────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MNColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // ── ListTile ───────────────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: MNColors.primaryLight,
      textColor: MNColors.onSurface,
    ),

    // ── Icon ───────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(color: MNColors.onSurface),

    // ── Tipografia ─────────────────────────────────────────────────────────
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: MNColors.onBackground,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: TextStyle(
        color: MNColors.onBackground,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        color: MNColors.onBackground,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: TextStyle(
        color: MNColors.onBackground,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: MNColors.onBackground,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        color: MNColors.onBackground,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: MNColors.onBackground,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: MNColors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: MNColors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: MNColors.onSurface),
      bodyMedium: TextStyle(color: MNColors.onSurface),
      bodySmall: TextStyle(color: MNColors.onSurfaceVar),
      labelLarge: TextStyle(
        color: MNColors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(color: MNColors.onSurfaceVar),
      labelSmall: TextStyle(color: MNColors.onSurfaceVar, fontSize: 10),
    ),
  );
}
