import 'dart:convert';
import 'package:country_app/core/connection/connectivity_checker.dart';
import 'package:country_app/core/model/country/country.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final ConnectivityChecker _connectivityChecker = ConnectivityChecker();

  final List<String> urls = [
    'https://restcountries.com/v3.1/translation/germany',
    'https://restcountries.com/v3.1/translation/india',
    'https://restcountries.com/v3.1/translation/israel',
    'https://restcountries.com/v3.1/translation/lanka',
    'https://restcountries.com/v3.1/translation/italy',
    'https://restcountries.com/v3.1/translation/china',
    'https://restcountries.com/v3.1/translation/korea',
  ];

  Future<Either<int, List<Country>>> fetchCountries() async {
    try {
      final hasInternet = await _connectivityChecker.hasInternetAccess();
      if (!hasInternet) {
        return left(0); // or any other code indicating no internet
      }

      // Fetch all responses in parallel
      final responses =
          await Future.wait(urls.map((url) => http.get(Uri.parse(url))));

      List<Country> countries = [];

      // Process each response
      for (var response in responses) {
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          for (var countryData in data) {
            countries.add(Country.fromJson(
                countryData)); // Convert JSON to Country object
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
        }
      }

      return right(countries); // Return the list of countries
    } catch (e) {
      debugPrint('from ctach ${e.toString()}');
      return left(1); // Return an error code
    }
  }
}
