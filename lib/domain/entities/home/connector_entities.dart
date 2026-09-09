import '../entity.dart';

// Connector entity

class ConnectorEntity extends Entity<int> {
  final int? unavailable;
  final int? available;
  final int? inuse;

  const ConnectorEntity({
    required int id,
    this.unavailable,
    this.available,
    this.inuse,
  }) : super(id);

  @override
  List<Object?> get props => [id, unavailable, available, inuse];
}
