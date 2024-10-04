import 'package:country_app/core/db/hive_db/adapter/country_adapter/country_adapter.dart';
import 'package:country_app/core/db/hive_db/box/country_box.dart';
import 'package:country_app/core/view_model/getcountryList/getcountry_list_bloc.dart';
import 'package:country_app/screen/home_screen.dart';
import 'package:country_app/screen/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  ///-------------Initialize Hive----------------------------
  Hive.registerAdapter(CountryCodeDBAdapter());
  Hive.registerAdapter(CountryHiveAdapter());
  countryCodeBox = await Hive.openBox<CountryCodeDB>('countryCodeBox');

  ///----------------lock in portrait mode------------------------------
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Run the app
  runApp(const CountryApp());
}

class CountryApp extends StatelessWidget {
  const CountryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetcountryListBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            HomeScreen(), // You can change this to HomeScreen or any other screen
      ),
    );
  }
}
//--------------------