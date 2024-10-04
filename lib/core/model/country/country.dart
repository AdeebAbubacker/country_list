class Country {
  final String commonName;
  final String officialName;
  final Map<String, dynamic> currency;
  final String region;
  
  final Map<String, String> flag;

  Country({
    required this.commonName,
    required this.officialName,
    required this.currency,
    required this.region,
    required this.flag,
  });

  // From JSON
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      commonName: json['name']['common'] ?? '',
      officialName: json['name']['official'] ?? '',
      currency: json['currencies'] != null
          ? Map<String, dynamic>.from(json['currencies'])
          : {},
      flag: json['flags'] != null
          ? {
              'png': json['flags']['png'] ?? '',
              'svg': json['flags']['svg'] ?? '',
              'alt': json['flags']['alt'] ?? ''
            }
          : {},
      region: json['region'] ?? '',
    );
  }
}
