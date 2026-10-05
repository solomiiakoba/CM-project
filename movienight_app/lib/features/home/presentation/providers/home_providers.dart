import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/home_local_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_quick_action.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_actions_usecase.dart';

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dataSource = ref.watch(homeLocalDataSourceProvider);
  return HomeRepositoryImpl(dataSource);
});

final getHomeActionsUseCaseProvider = Provider<GetHomeActionsUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetHomeActionsUseCase(repository);
});

final homeActionsProvider = Provider<List<HomeQuickAction>>((ref) {
  final getHomeActions = ref.watch(getHomeActionsUseCaseProvider);
  return getHomeActions();
});
