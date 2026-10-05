enum HomeActionType {
  createSession,
  joinSession,
  bluetoothTest,
}

class HomeQuickAction {
  final HomeActionType type;
  final String titleKey;
  final bool isPrimary;

  const HomeQuickAction({
    required this.type,
    required this.titleKey,
    this.isPrimary = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeQuickAction &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          titleKey == other.titleKey &&
          isPrimary == other.isPrimary;

  @override
  int get hashCode => Object.hash(type, titleKey, isPrimary);
}
