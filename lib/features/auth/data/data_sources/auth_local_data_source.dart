import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCurrentUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<void> clearCurrentUser();
  Future<List<UserModel>> getUsers();
  Future<void> saveUsers(List<UserModel> users);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  Box get _box => Hive.box(AppConstants.authBox);

  static const String _currentUserKey = 'current_user';
  static const String _usersKey = 'users';

  @override
  Future<void> saveCurrentUser(UserModel user) async {
    await _box.put(_currentUserKey, user.toHiveMap());
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final raw = _box.get(_currentUserKey);
    if (raw == null) return null;
    return UserModel.fromHiveMap(raw as Map);
  }

  @override
  Future<void> clearCurrentUser() async {
    await _box.delete(_currentUserKey);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final raw = _box.get(_usersKey);
    if (raw == null) return [];
    final list = (raw as List).cast<Map>();
    return list.map(UserModel.fromHiveMap).toList();
  }

  @override
  Future<void> saveUsers(List<UserModel> users) async {
    final payload = users.map((user) => user.toHiveMap()).toList();
    await _box.put(_usersKey, payload);
  }
}
