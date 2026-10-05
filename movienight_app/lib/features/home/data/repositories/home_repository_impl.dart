import '../../domain/entities/home_quick_action.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  List<HomeQuickAction> getQuickActions() {
    return _dataSource.getQuickActions();
  }
}
