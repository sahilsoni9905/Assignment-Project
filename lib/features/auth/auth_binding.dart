import 'package:get/get.dart';
import 'package:tuff_project/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:tuff_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tuff_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:tuff_project/features/auth/domain/usecases/auth_usecases.dart';
import 'package:tuff_project/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthLocalDataSource>()),
      fenix: true,
    );

    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(
      () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UpdateProfileUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(
          loginUseCase: Get.find<LoginUseCase>(),
          registerUseCase: Get.find<RegisterUseCase>(),
          logoutUseCase: Get.find<LogoutUseCase>(),
          getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        ),
        permanent: true,
      );
    }
  }
}
