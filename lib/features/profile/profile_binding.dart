import 'package:get/get.dart';
import 'package:tuff_project/features/auth/domain/usecases/auth_usecases.dart';
import 'package:tuff_project/features/balances/domain/usecases/balances_usecase.dart';
import 'package:tuff_project/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:tuff_project/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:tuff_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:tuff_project/features/profile/domain/usecases/profile_usecase.dart';
import 'package:tuff_project/features/profile/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileLocalDataSource>(() => ProfileLocalDataSourceImpl());
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ProfileLocalDataSource>()),
    );
    Get.lazyPut(() => ProfileUseCase(Get.find<ProfileRepository>()));
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<ProfileUseCase>(),
        Get.find<GetCurrentUserUseCase>(),
        Get.find<UpdateProfileUseCase>(),
        Get.find<BalancesUseCase>(),
      ),
    );
  }
}
