abstract class ProfileRepository {
  Future<void> saveItem(String key, dynamic value);
  Future<dynamic> getItem(String key);
}
