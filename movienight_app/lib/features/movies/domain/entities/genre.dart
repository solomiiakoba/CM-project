/// Domain entity representing a movie genre with localized names.
class Genre {
  final int id;
  final String namePt;
  final String nameEn;

  const Genre({
    required this.id,
    required this.namePt,
    required this.nameEn,
  });

  /// Returns the localized name for the given language code ('pt' or 'en').
  String localized(String langCode) => langCode.toLowerCase().startsWith('en') ? nameEn : namePt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Genre && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Genre(id: $id, pt: $namePt, en: $nameEn)';
}
