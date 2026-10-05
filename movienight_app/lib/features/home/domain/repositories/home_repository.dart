import '../entities/home_quick_action.dart';

abstract class HomeRepository {
  List<HomeQuickAction> getQuickActions();
}
