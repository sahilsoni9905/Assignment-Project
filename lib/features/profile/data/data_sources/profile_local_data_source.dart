import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveData(String key, dynamic value);
  Future<dynamic> getData(String key);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  Box get _box => Hive.box(AppConstants.ProfileBox);

  @override
  Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  @override
  Future<dynamic> getData(String key) async {
    return _box.get(key);
  }
}
