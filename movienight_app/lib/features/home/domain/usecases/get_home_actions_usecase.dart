import '../entities/home_quick_action.dart';
import '../repositories/home_repository.dart';

class GetHomeActionsUseCase {
  final HomeRepository _repository;

  GetHomeActionsUseCase(this._repository);

  List<HomeQuickAction> call() => _repository.getQuickActions();
}
