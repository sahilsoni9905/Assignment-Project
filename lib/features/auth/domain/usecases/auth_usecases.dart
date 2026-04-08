import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.login(email, password);
  }
}

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<UserEntity> call(String name, String email, String password) {
    return _repository.register(name, email, password);
  }
}

class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  Future<void> call() {
    return _repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  Future<UserEntity?> call() {
    return _repository.getCurrentUser();
  }
}

class UpdateProfileUseCase {
  final AuthRepository _repository;
  UpdateProfileUseCase(this._repository);

  Future<UserEntity> call({
    required String id,
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.updateProfile(
      id: id,
      name: name,
      email: email,
      password: password,
    );
  }
}
