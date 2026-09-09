import '../../domain.dart';
import '../entity.dart';

// history entity

class HistoryEntity extends Entity<int> {
  final List<HistoryListEntity>? records;
  final String? next;

  const HistoryEntity({required int id, this.records, this.next}) : super(id);

  @override
  List<Object?> get props => [id, records, next];
}
