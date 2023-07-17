import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/counties%20list%20Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid_tracker/Models/WorldStatesModel.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorlist = <Color>[
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(left: 10.0,top: 45.0,right:10.0 ),
          child: Column(
            children: [

              FutureBuilder(
                  future: statesServices.fatchWorldStatesRecord(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                          child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _controller,
                      ));
                    } else {
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total": double.parse(
                                  snapshot.data!.cases!.toString()),
                              "Recovered": double.parse(
                                  snapshot.data!.recovered.toString()),
                              "Deaths": double.parse(
                                  snapshot.data!.deaths.toString()),
                            },
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: true,
                              decimalPlaces: 1,
                            ),
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.7,
                            legendOptions: LegendOptions(
                                legendPosition: LegendPosition.left),
                            animationDuration: Duration(milliseconds: 1500),
                            chartType: ChartType.ring,
                            colorList: colorlist,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Card(
                                child: Column(
                              children: [
                                ReusableRow(
                                    title: 'Total Cases',
                                    value: snapshot.data!.cases.toString()),
                                ReusableRow(
                                    title: 'Deaths',
                                    value: snapshot.data!.deaths.toString()),
                                ReusableRow(
                                    title: 'Recovered',
                                    value: snapshot.data!.recovered.toString()),
                                ReusableRow(
                                    title: 'Active',
                                    value: snapshot.data!.active.toString()),
                                ReusableRow(
                                    title: 'Critical',
                                    value: snapshot.data!.critical.toString()),
                                ReusableRow(
                                    title: 'Today Deaths',
                                    value:
                                        snapshot.data!.todayDeaths.toString()),
                                ReusableRow(
                                    title: 'Today Recovered',
                                    value: snapshot.data!.todayRecovered
                                        .toString()),
                              ],
                            )),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .08,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                    context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CountiesListScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              child: Center(child: Text('Track countries')),
                            ),
                          )
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;

  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          SizedBox(
            height: 5,
          ),
          Divider()
        ],
      ),
    );
  }
}
