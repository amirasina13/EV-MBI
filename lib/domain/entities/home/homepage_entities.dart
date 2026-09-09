import '../../domain.dart';
import '../entity.dart';

// home entity

class HomeEntity extends Entity<int> {
  final TotalEntity? total;
  final List<LocationHomeEntity>? locations;

  const HomeEntity({required int id, this.total, this.locations}) : super(id);

  @override
  List<Object?> get props => [id, total, locations];
}
