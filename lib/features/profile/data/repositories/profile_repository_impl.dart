import 'package:tuff_project/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:tuff_project/features/profile/domain/repositories/profile_repository.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _localDataSource;

  ProfileRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveItem(String key, dynamic value) async {
    await _localDataSource.saveData(key, value);
  }

  @override
  Future<dynamic> getItem(String key) async {
    return _localDataSource.getData(key);
  }
}
