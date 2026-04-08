import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.password,
  });

  factory UserModel.fromHiveMap(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      password: (map['password'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      token: token,
      password: password,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      token: entity.token,
      password: entity.password,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, email: $email)';
}
