class CountryHiveModel {
  final String commonName;
  final String officialName;
  final Map<String, dynamic> currency;
  final Map<String, String> flag;

  CountryHiveModel({
    required this.commonName,
    required this.officialName,
    required this.currency,
    required this.flag,
  });
}