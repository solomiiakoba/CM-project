import '../../domain/entities/home_quick_action.dart';

abstract class HomeLocalDataSource {
  List<HomeQuickAction> getQuickActions();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  List<HomeQuickAction> getQuickActions() {
    return const [
      HomeQuickAction(
        type: HomeActionType.createSession,
        titleKey: 'newSession',
        isPrimary: true,
      ),
      HomeQuickAction(
        type: HomeActionType.joinSession,
        titleKey: 'joinSession',
        isPrimary: false,
      ),
      HomeQuickAction(
        type: HomeActionType.bluetoothTest,
        titleKey: 'bluetoothPeripheral',
        isPrimary: false,
      ),
    ];
  }
}
