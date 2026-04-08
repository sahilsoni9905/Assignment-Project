import '../repositories/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository _repository;

  ProfileUseCase(this._repository);

  Future<void> saveItem(String key, dynamic value) async {
    await _repository.saveItem(key, value);
  }

  Future<dynamic> getItem(String key) async {
    return _repository.getItem(key);
  }
}
