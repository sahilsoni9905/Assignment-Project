import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase;

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSignInSelected = true.obs;
  final RxBool isSignInPasswordVisible = false.obs;
  final RxBool isSignUpPasswordVisible = false.obs;
  final RxBool isSignUpConfirmPasswordVisible = false.obs;
  final RxBool isButtonLoading = false.obs;

  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();
  final TextEditingController signUpNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();

  bool _isCheckingSession = false;

  @override
  void onInit() {
    super.onInit();
    checkSession();
  }

  @override
  void onClose() {
    signInEmailController.dispose();
    signInPasswordController.dispose();
    signUpNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> checkSession() async {
    if (_isCheckingSession) return;
    _isCheckingSession = true;
    isLoading.value = true;
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        currentUser.value = user;
        if (Get.currentRoute != AppRoutes.home) {
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        if (Get.currentRoute != AppRoutes.auth) {
          Get.offAllNamed(AppRoutes.auth);
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      if (Get.currentRoute != AppRoutes.auth) {
        Get.offAllNamed(AppRoutes.auth);
      }
    } finally {
      isLoading.value = false;
      _isCheckingSession = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      print('Attempting login with email: $email');

      isButtonLoading.value = true;

      errorMessage.value = '';

      final user = await _loginUseCase(email, password);
      currentUser.value = user;
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print('Login error: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Login failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isButtonLoading.value = false;
    }
  }

  Future<void> signIn() async {
    final email = signInEmailController.text.trim();
    final password = signInPasswordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email and password are required.';
      return;
    }
    await login(email, password);
  }

  Future<void> signUp() async {
    final name = signUpNameController.text.trim();
    final email = signUpEmailController.text.trim();
    final password = signUpPasswordController.text.trim();
    final confirmPassword = signUpConfirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage.value = 'All fields are required.';
      return;
    }
    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await _registerUseCase(name, email, password);
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.auth);
  }
}
