import 'package:country_app/core/db/hive_db/adapter/country_adapter/country_adapter.dart';
import 'package:country_app/core/db/hive_db/box/country_box.dart';
import 'package:country_app/core/view_model/getcountryList/getcountry_list_bloc.dart';
import 'package:country_app/widget/card_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAscending = true; // Flag to track the current sort order
  String? selectedContinent =
      'All'; // Default to 'All' for showing all countries
  final ScrollController _scrollController = ScrollController();
  final List<String> continents = [
    'All', // For showing all countries
    'Africa',
    'Americas',
    'Asia',
    'Europe',
    'Oceania',
  ];
  bool isApiCalled = false;

  void _scrollListener() {
    if (_scrollController.offset < 0 && !isApiCalled) {
      setState(() {
        isApiCalled = true;
      });
      context
          .read<GetcountryListBloc>()
          .add(const GetcountryListEvent.fetchAllQuestionBank());
      print("API called once!");
    }

    if (_scrollController.offset >= 0 && isApiCalled) {
      setState(() {
        isApiCalled = false; // Unblock API call
      });
      print("API call unblocked!");
    }
  }

  void toggleSortOrder() {
    setState(() {
      isAscending = !isAscending;
    });
  }

  void filterByContinent(String? continent) {
    setState(() {
      selectedContinent = continent;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
      context
          .read<GetcountryListBloc>()
          .add(const GetcountryListEvent.fetchAllQuestionBank());
    });
  }

  String getCurrencyName(Map<String, dynamic> currencies) {
    if (currencies.isNotEmpty) {
      final currency =
          currencies.values.first; // Get the first currency in the map
      return '${currency['name']}';
    }
    return 'Currency not available';
  }

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    return items.map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  List<double> _getCustomItemsHeights() {
    return List<double>.filled(continents.length, 48);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetcountryListBloc, GetcountryListState>(
      listener: (context, state) async {
        state.maybeMap(
          orElse: () {
            print('No countries available');
          },
          createdQuestionBank: (value) async {
            if (!Hive.isBoxOpen('countryCodeBox')) {
              countryCodeBox =
                  await Hive.openBox<CountryHive>('countryCodeBox');
            }

            await countryCodeBox.clear();
            List<CountryCodeDB> countries = value.questionBank.map((country) {
              return CountryCodeDB(
                questionBank: [
                  CountryHive(
                    commonName: country.commonName.toString(),
                    officialName: country.officialName.toString(),
                    currency: getCurrencyName(country.currency).toString(),
                    flag: country.flag['png'].toString() ?? '',
                    region: country.region.toString(),
                  )
                ],
              );
            }).toList();

            for (int i = 0; i < countries.length; i++) {
              await countryCodeBox.put(i, countries[i]);
            }
//-----------------------
            print('Data stored in Hive successfully!');
          },
        );
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 35),
              isApiCalled == true
                  ? SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 30.0,
                    )
                  : SizedBox(),
              const SizedBox(height: 20),
              const Text(
                "COUNTRY LIST",
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 246, 246),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text(
                            'Select Your Continent',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: _addDividersAfterItems(continents),
                          value: selectedContinent,
                          onChanged: (String? value) {
                            setState(() {
                              selectedContinent = value;
                            });
                            filterByContinent(value);
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights: _getCustomItemsHeights(),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(isAscending
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded),
                    onPressed: toggleSortOrder,
                    tooltip: 'Sort by Alphabetical Order',
                  ),
                ],
              ),
              ValueListenableBuilder<Box<CountryCodeDB>>(
                valueListenable:
                    Hive.box<CountryCodeDB>('countryCodeBox').listenable(),
                builder: (context, box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  List<CountryCodeDB> storedData = box.values.toList();
                  List<CountryHive> countryList = [];
                  for (var countryCode in storedData) {
                    for (var country in countryCode.questionBank) {
                      if (selectedContinent == 'All' ||
                          country.region == selectedContinent) {
                        countryList.add(country);
                      }
                    }
                  }

                  countryList.sort((a, b) {
                    if (isAscending) {
                      return a.commonName.compareTo(b.commonName);
                    } else {
                      return b.commonName.compareTo(a.commonName);
                    }
                  });

                  return countryList.isEmpty
                      ? const Center(
                          child: Column(
                          children: [
                            SizedBox(height: 30),
                            Text('No countries match your criteria'),
                          ],
                        ))
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: countryList.length,
                          itemBuilder: (context, index) {
                            final country = countryList[index];
                            return CardWidget(
                              imgUrl: country.flag,
                              officialName: country.officialName,
                              commonName: country.commonName,
                              currencyName: country.currency,
                            );
                          },
                        );
                },
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
