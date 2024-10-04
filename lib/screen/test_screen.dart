// import 'package:country_app/core/db/hive_db/adapter/country_adapter/country_adapter.dart';
// import 'package:country_app/core/db/hive_db/box/country_box.dart';
// import 'package:country_app/core/view_model/getcountryList/getcountry_list_bloc.dart';
// import 'package:country_app/widget/card_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shimmer/shimmer.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<CountryHive> countryList =
//       []; // List to hold the country data for displaying in the UI.
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchData();
//       context
//           .read<GetcountryListBloc>()
//           .add(const GetcountryListEvent.fetchAllQuestionBank());
//     });
//   }

//   List<CountryHive> filteredCountryList =
//       []; // Filtered list based on continent
//   bool isAscending = true; // Flag to track the current sort order
//   String? selectedContinent =
//       'All'; // Default to 'All' for showing all countries

//   final List<String> continents = [
//     'All', // For showing all countries
//     'Africa',
//     'Americas',
//     'Asia',
//     'Europe',
//     'Oceania',
//   ];

//   void toggleSortOrder() {
//     setState(() {
//       isAscending = !isAscending;
//       filteredCountryList.sort((a, b) => isAscending
//           ? a.commonName.compareTo(b.commonName)
//           : b.commonName.compareTo(a.commonName));
//     });
//   }

//   void filterByContinent(String? continent) {
//     setState(() {
//       selectedContinent = continent;

//       if (continent == 'All') {
//         // Show all countries if 'All' is selected
//         filteredCountryList = List.from(countryList);
//       } else {
//         // Filter the list based on the selected continent
//         filteredCountryList = countryList
//             .where((country) => country.region == continent)
//             .toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 235, 235, 235),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             const SizedBox(height: 70),
//             const Text(
//               "COUNTRY LIST",
//               style: TextStyle(color: Colors.black, fontSize: 30),
//             ),
//             SizedBox(
//               height: 50,
//               width: 200,
//               child: Row(
//                 children: [
//                   SizedBox(width: 20),
//                   IconButton(
//                     icon: Icon(isAscending
//                         ? Icons.sort_by_alpha // Ascending
//                         : Icons.sort), // Descending
//                     onPressed: toggleSortOrder,
//                     tooltip: 'Sort by Alphabetical Order',
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: DropdownButton<String>(
//                 value: selectedContinent,
//                 onChanged: (newValue) {
//                   filterByContinent(newValue);
//                 },
//                 items: continents.map((continent) {
//                   return DropdownMenuItem<String>(
//                     value: continent,
//                     child: Text(continent),
//                   );
//                 }).toList(),
//                 isExpanded: true,
//                 hint: const Text('Select Continent'),
//               ),
//             ),
//             BlocConsumer<GetcountryListBloc, GetcountryListState>(
//               listener: (context, state) async {
//                 state.maybeMap(
//                   orElse: () {
//                     print('No countries available');
//                   },
//                   createdQuestionBank: (value) async {
//                     // If the box is not already open, open it here (this should ideally be done in `main.dart` or a service initialization)
//                     if (!Hive.isBoxOpen('countryCodeBox')) {
//                       countryCodeBox =
//                           await Hive.openBox<CountryHive>('countryCodeBox');
//                     }

//                     // Clear the box before storing new data (optional)
//                     await countryCodeBox.clear();

//                     // Map the API data to a list of CountryHive objects
//                     List<CountryCodeDB> countries =
//                         value.questionBank.map((country) {
//                       return CountryCodeDB(
//                         questionBank: [
//                           CountryHive(
//                             commonName: country.commonName.toString(),
//                             officialName: country.officialName.toString(),
//                             currency:
//                                 getCurrencyName(country.currency).toString(),
//                             flag: country.flag['png'].toString() ?? '',
//                             region: country.region.toString(),
//                           )
//                         ],
//                       );
//                     }).toList();

//                     // Store each CountryHive object individually in Hive
//                     for (int i = 0; i < countries.length; i++) {
//                       await countryCodeBox.put(i, countries[i]);
//                     }

//                     print('Data stored in Hive successfully!');
//                   },
//                 );
//               },
//               builder: (context, state) {
//                 return state.maybeMap(
//                   orElse: () {
//                     return const Center(
//                         child: Text('Unexpected Error Occurred'));
//                   },
//                   initial: (value) {
//                     return const Center(child: Text('Fetching data...'));
//                   },
//                   error: (value) {
//                     return const Center(
//                         child: Text('Error occurred while loading'));
//                   },
//                   loading: (value) {
//                     // Shimmer loading animation
//                     return ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: 10, // Simulate 10 placeholders
//                       itemBuilder: (context, index) {
//                         return SizedBox(
//                           height: 130,
//                           width: double.infinity,
//                           child: Shimmer.fromColors(
//                             baseColor: Colors.grey[300]!,
//                             highlightColor: Colors.grey[100]!,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 8,
//                                         right: 8,
//                                       ),
//                                       child: Container(
//                                         width: 120,
//                                         height: 80,
//                                         decoration: BoxDecoration(
//                                             color: Colors.grey,
//                                             borderRadius:
//                                                 BorderRadius.circular(4)),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(right: 5),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           height: 20,
//                                           decoration: BoxDecoration(
//                                               color: Colors.grey,
//                                               borderRadius:
//                                                   BorderRadius.circular(4)),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Container(
//                                           height: 20,
//                                           decoration: BoxDecoration(
//                                               color: Colors.grey,
//                                               borderRadius:
//                                                   BorderRadius.circular(4)),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Container(
//                                           height: 20,
//                                           decoration: BoxDecoration(
//                                               color: Colors.grey,
//                                               borderRadius:
//                                                   BorderRadius.circular(4)),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   noInternet: (value) {
//                     return const Center(child: Text('No Internet Connection'));
//                   },
//                   createdQuestionBank: (value) {

//                     return filteredCountryList.isEmpty
//                         ? const Center(child: Text('No data available'))
//                         : Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ListView.builder(
//                               physics: const BouncingScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: filteredCountryList.length,
//                               itemBuilder: (context, index) {
//                                 return CardWidget(
//                                   imgUrl: filteredCountryList[index].flag,
//                                   officialName:
//                                       filteredCountryList[index].officialName,
//                                   commonName:
//                                       filteredCountryList[index].commonName,
//                                   currencyName:
//                                       filteredCountryList[index].currency,
//                                 );
//                               },
//                             ),
//                           );
//                   },
//                 );
//               },
//             ),
//             const SizedBox(height: 70),
//           ],
//         ),
//       ),
//     );
//   }

//   String getCurrencyName(Map<String, dynamic> currencies) {
//     if (currencies != null && currencies.isNotEmpty) {
//       final currency =
//           currencies.values.first; // Get the first currency in the map
//       return '${currency['name']} '; // Name and symbol
//     }
//     return 'Currency not available'; // Fallback if no currency data
//   }

//   Future<void> fetchData() async {
//     var storedData =
//         countryCodeBox.values.toList(); // Get all values from the Hive box

//     List<CountryHive> newCountryList = [];

//     if (storedData.isNotEmpty) {
//       for (var country in storedData) {
//         if (country is CountryCodeDB) {
//           for (var countryItem in country.questionBank) {
//             newCountryList.add(CountryHive(
//               commonName: countryItem.commonName,
//               officialName: countryItem.officialName,
//               currency: countryItem.currency,
//               flag: countryItem.flag,
//               region: countryItem.region,
//             ));
//           }
//         }
//       }

//       // Update the state with the new data
//       setState(() {
//         countryList = newCountryList;
//       });
//     }
//   }
// }