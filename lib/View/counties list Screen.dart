import 'package:covid_tracker/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Services/states_services.dart';

class CountiesListScreen extends StatefulWidget {
  const CountiesListScreen({Key? key}) : super(key: key);

  @override
  State<CountiesListScreen> createState() => _CountiesListScreenState();
}

class _CountiesListScreenState extends State<CountiesListScreen> {
  TextEditingController searchControlor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: searchControlor,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'search here',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: statesServices.countriesListApi(),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              String name = snapshot.data![index]['country'];

                              if (searchControlor.text.isEmpty) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                  image: snapshot.data![index]
                                                      ['countryInfo']['flag'],
                                                  name: snapshot.data![index]
                                                      ['country'],
                                                  totalCases: snapshot
                                                      .data![index]['cases'],
                                                  totalRecovered:
                                                      snapshot.data![index]
                                                          ['recovered'],
                                                  totalDeaths: snapshot
                                                      .data![index]['deaths'],
                                                  active: snapshot.data![index]
                                                      ['active'],
                                                  test: snapshot.data![index]
                                                      ['tests'],
                                                  todayRecovered:
                                                      snapshot.data![index]
                                                          ['todayRecovered'],
                                                  critical: snapshot
                                                      .data![index]['critical'],
                                                )));
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Image(
                                          height: 50,
                                          width: 50,
                                          image: NetworkImage(
                                              snapshot.data![index]
                                                  ['countryInfo']['flag']),
                                        ),
                                        title: Text(
                                            snapshot.data![index]['country']),
                                        subtitle: Text("Effected: " +
                                            snapshot.data![index]['cases']
                                                .toString()),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (name.toLowerCase().contains(
                                  searchControlor.text.toLowerCase())) {
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                            snapshot.data![index]['countryInfo']
                                                ['flag']),
                                      ),
                                      title: Text(
                                          snapshot.data![index]['country']),
                                      subtitle: Text("Effected: " +
                                          snapshot.data![index]['cases']
                                              .toString()),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        return ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade700,
                              highlightColor: Colors.grey.shade100,
                              enabled: true,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.white,
                                    ),
                                    title: Container(
                                      width: 100,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    subtitle: Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
