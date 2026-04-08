class HomeEntity {
  final String id;
  final String title;
  final dynamic data;

  const HomeEntity({
    required this.id,
    required this.title,
    this.data,
  });

  @override
  String toString() => 'HomeEntity(id: $id, title: $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
