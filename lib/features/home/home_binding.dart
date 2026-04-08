import 'package:get/get.dart';
import 'package:tuff_project/features/home/data/data_sources/feature1_local_data_source.dart';
import 'package:tuff_project/features/home/data/repositories/home_repo_impl.dart';
import 'package:tuff_project/features/home/domain/usecases/home_usecase.dart';
import 'package:tuff_project/features/home/presentation/controllers/home_controller.dart';
import 'package:tuff_project/features/auth/domain/usecases/auth_usecases.dart';

class Feature1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Feature1LocalDataSource>(() => Feature1LocalDataSourceImpl());
    Get.lazyPut<HomeRepositoryImpl>(
      () => HomeRepositoryImpl(Get.find<Feature1LocalDataSource>()),
    );
    Get.lazyPut(() => HomeUseCase(Get.find<HomeRepositoryImpl>()));
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(
        HomeController(
          Get.find<HomeUseCase>(),
          Get.find<GetCurrentUserUseCase>(),
        ),
      );
    }
  }
}
