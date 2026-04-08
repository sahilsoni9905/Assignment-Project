import '../../domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<UserEntity> updateProfile({
    required String id,
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
