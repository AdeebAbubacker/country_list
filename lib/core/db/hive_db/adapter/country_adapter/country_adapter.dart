import 'package:hive_flutter/hive_flutter.dart';
part 'country_adapter.g.dart';

@HiveType(typeId: 1)
class CountryCodeDB {
  @HiveField(0)
  final List<CountryHive> questionBank;

  CountryCodeDB({
    required this.questionBank,
  });
}

@HiveType(typeId: 2) // Unique typeId for Country class
class CountryHive {
  @HiveField(1)
  final String commonName;

  @HiveField(2)
  final String officialName;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final String flag;
  @HiveField(5)
  final String region;

  CountryHive({
    required this.commonName,
    required this.officialName,
    required this.currency,
    required this.flag,
    this.region = '',
  });
}
