import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuff_project/features/balances/domain/usecases/balances_usecase.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/usecases/auth_usecases.dart';
import '../../domain/usecases/profile_usecase.dart';

class ProfileController extends GetxController {
  final ProfileUseCase _useCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final BalancesUseCase _balancesUseCase;

  ProfileController(
    this._useCase,
    this._getCurrentUserUseCase,
    this._updateProfileUseCase,
    this._balancesUseCase,
  );

  final RxBool isLoading = false.obs;
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);

  final RxBool isPreviewSelected = true.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalSpendings = 0.0.obs;
  final RxDouble remainingBalance = 0.0.obs;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> _loadCurrentUser() async {
    isLoading.value = true;
    currentUser.value = await _getCurrentUserUseCase();
    _fillForm(currentUser.value);
    await _loadMonthlySummary();
    isLoading.value = false;
  }

  Future<void> _loadMonthlySummary() async {
    final user = currentUser.value;
    if (user == null) {
      totalSpendings.value = 0;
      remainingBalance.value = 0;
      return;
    }
    final summary = await _balancesUseCase.getAllTimeSummary(user.id);
    totalSpendings.value = summary.totalExpense;
    remainingBalance.value = summary.remainingBalance;
  }

  void selectPreview() {
    isPreviewSelected.value = true;
    errorMessage.value = '';
  }

  void selectEdit() {
    isPreviewSelected.value = false;
    errorMessage.value = '';
  }

  void _fillForm(UserEntity? user) {
    if (user == null) return;
    fullNameController.text = user.name;
    emailController.text = user.email;
    passwordController.text = user.password;
    confirmPasswordController.text = user.password;
  }

  Future<void> submitProfileUpdate() async {
    final user = currentUser.value;
    if (user == null) return;

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage.value = 'All fields are required.';
      return;
    }
    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match.';
      return;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';
      final updatedUser = await _updateProfileUseCase(
        id: user.id,
        name: name,
        email: email,
        password: password,
      );
      currentUser.value = updatedUser;
      _fillForm(updatedUser);
      isPreviewSelected.value = true;
      Get.snackbar('Profile updated', 'Your changes have been saved.');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSaving.value = false;
    }
  }
}
