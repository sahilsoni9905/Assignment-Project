import 'package:get/get.dart';
import 'package:tuff_project/features/auth/domain/usecases/auth_usecases.dart';
import 'package:tuff_project/features/balances/data/data_sources/balances_local_data_source.dart';
import 'package:tuff_project/features/balances/data/repositories/balances_repository_impl.dart';
import 'package:tuff_project/features/balances/domain/usecases/balances_usecase.dart';
import 'package:tuff_project/features/balances/presentation/controllers/balances_controller.dart';

class BalancesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BalancesLocalDataSource>(() => BalancesLocalDataSourceImpl());
    Get.lazyPut<BalancesRepositoryImpl>(
      () => BalancesRepositoryImpl(Get.find<BalancesLocalDataSource>()),
    );
    Get.lazyPut(() => BalancesUseCase(Get.find<BalancesRepositoryImpl>()));
    Get.lazyPut<BalancesController>(
      () => BalancesController(
        Get.find<BalancesUseCase>(),
        Get.find<GetCurrentUserUseCase>(),
      ),
    );
  }
}
