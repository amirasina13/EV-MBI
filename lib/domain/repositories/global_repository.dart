import '../../data/data.dart';

abstract class GlobalRepository {
  Future<List<CountryList>> getCountries();
}
