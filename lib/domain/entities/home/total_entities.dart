import '../entity.dart';

// Total entity

class TotalEntity extends Entity<int> {
  final int? locations;
  final int? connectors;
  final int? available;

  const TotalEntity({
    required int id,
    this.locations,
    this.connectors,
    this.available,
  }) : super(id);

  @override
  List<Object?> get props => [id, locations, connectors, available];
}
