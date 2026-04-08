class BalancesEntity {
  final String id;
  final String title;
  final dynamic data;

  const BalancesEntity({required this.id, required this.title, this.data});

  @override
  String toString() => 'balancesEntity(id: $id, title: $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalancesEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
