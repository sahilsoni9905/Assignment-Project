class UserEntity {
  final String id;
  final String name;
  final String email;
  final String token;
  final String password;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.password = '',
  });

  @override
  String toString() => 'UserEntity(id: $id, email: $email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
