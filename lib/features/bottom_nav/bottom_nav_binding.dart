import 'package:get/get.dart';
import 'package:tuff_project/features/bottom_nav/presentation/controllers/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
