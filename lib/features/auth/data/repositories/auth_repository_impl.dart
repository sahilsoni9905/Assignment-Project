import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final users = await _localDataSource.getUsers();
    final matched = users.where((u) => u.email == email).toList();
    if (matched.isEmpty) {
      throw Exception('No user found for this email.');
    }
    final user = matched.first;
    if (user.password != password) {
      throw Exception('Incorrect password.');
    }

    await _localDataSource.saveCurrentUser(user);
    return user.toEntity();
  }

  @override
  Future<UserEntity> register(
    String name,
    String email,
    String password,
  ) async {
    final users = await _localDataSource.getUsers();
    final exists = users.any((u) => u.email == email);
    if (exists) {
      throw Exception('Email is already registered.');
    }

    final model = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      token: 'local_token_$email',
      password: password,
    );

    final updated = [...users, model];
    await _localDataSource.saveUsers(updated);
    await _localDataSource.saveCurrentUser(model);

    return model.toEntity();
  }

  @override
  Future<UserEntity> updateProfile({
    required String id,
    required String name,
    required String email,
    required String password,
  }) async {
    final users = await _localDataSource.getUsers();
    final index = users.indexWhere((u) => u.id == id);
    if (index == -1) {
      throw Exception('User not found.');
    }

    final emailExists = users.any((u) => u.email == email && u.id != id);
    if (emailExists) {
      throw Exception('Email is already registered.');
    }

    final existing = users[index];
    final updatedUser = UserModel(
      id: existing.id,
      name: name,
      email: email,
      token: existing.token,
      password: password,
    );

    final updatedUsers = [...users];
    updatedUsers[index] = updatedUser;
    await _localDataSource.saveUsers(updatedUsers);
    await _localDataSource.saveCurrentUser(updatedUser);

    return updatedUser.toEntity();
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearCurrentUser();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final model = await _localDataSource.getCurrentUser();
    return model?.toEntity();
  }
}
