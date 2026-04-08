class ProfileEntity {
  final String id;
  final String title;
  final dynamic data;

  const ProfileEntity({required this.id, required this.title, this.data});

  @override
  String toString() => 'ProfileEntity(id: $id, title: $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
