import 'package:coin_tracker/content.dart';
import 'package:coin_tracker/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const kBigCardTextStyle = TextStyle(
  fontSize: 45,
  fontWeight: FontWeight.bold,
);

const kBigCardNumberStyle = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.bold,
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String coinValueChosen = coins[0]["id"];
  String currencyValueChosen = currencies[0]["id"];
  NetworkHelper networkHelper;

  @override
  void initState() {
    super.initState();

    networkHelper = getUrl(coinValueChosen, currencyValueChosen);
  }

  NetworkHelper getUrl(String coin, String curr) {
    return NetworkHelper(
        url:
            'https://rest.coinapi.io/v1/exchangerate/$coin/$curr?apikey=1FFC711A-4741-4BB9-A7B9-3AD079FCB4AE');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFB52175),
                Color(0xFF3C68BB),
              ],
            ),
          ),
        ),
        title: Text(
          "Coin Tracker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    "images/logo.png",
                    width: 60,
                  ),
                  applicationName: "Coin Tracker",
                  applicationVersion: "1.1.1",
                  applicationLegalese: "venomShakib");
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  CustomSmallCard(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: coinValueChosen,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        dropdownColor: Color(0xFF3C68BB),
                        iconEnabledColor: Colors.white,
                        onChanged: (String value) {
                          setState(() {
                            coinValueChosen = value;
                            networkHelper =
                                getUrl(coinValueChosen, currencyValueChosen);
                          });
                        },
                        items: coins
                            .map(
                              (value) => DropdownMenuItem(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/coins/${value["id"]}.png',
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(value["name"]),
                                  ],
                                ),
                                value: value["id"],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    color: Color(0xFF3C68BB),
                  ),
                  CustomSmallCard(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currencyValueChosen,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        dropdownColor: Color(0xFFB52175),
                        iconEnabledColor: Colors.white,
                        onChanged: (String value) {
                          setState(() {
                            currencyValueChosen = value;
                            networkHelper =
                                getUrl(coinValueChosen, currencyValueChosen);
                          });
                        },
                        items: currencies
                            .map(
                              (value) => DropdownMenuItem(
                                child: Text(value["name"]),
                                value: value["id"],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    color: Color(0xFFB52175),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Container(
                  child: Center(
                    child: Stack(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: IconButton(
                              tooltip: "Refresh",
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                              onPressed: () {
                                setState(() {
                                  networkHelper = getUrl(
                                      coinValueChosen, currencyValueChosen);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      FutureBuilder(
                        future: networkHelper.getCoinRate(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error Fetching data from internet"),
                            );
                          } else if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(
                              child: SpinKitWave(
                                color: Colors.white,
                                size: 30.0,
                              ),
                            );
                          } else {
                            final data = snapshot.data;
                            if (data["rate"] == null) {
                              return Center(
                                child: Text("Something went wrong."),
                              );
                            } else
                              return Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "1",
                                            style: kBigCardNumberStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "$coinValueChosen",
                                            style: kBigCardTextStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "${data["rate"].toStringAsFixed(2)}",
                                            style: kBigCardNumberStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "$currencyValueChosen",
                                            style: kBigCardTextStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                          }
                        },
                      ),
                    ]),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 5,
                      color: Colors.white,
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 3,
                        blurRadius: 10,
                        color: Colors.grey[600],
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.5, 0.9],
                      colors: [
                        Color(0xFFB52175),
                        Color(0xFF3C68BB),
                        Color(0xFF0B837C),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSmallCard extends StatelessWidget {
  final Color color;
  final Widget child;

  const CustomSmallCard({@required this.child, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: child,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              offset: Offset.fromDirection(20, 7),
              blurRadius: 15,
              color: Colors.grey[600],
            ),
          ],
          color: color,
        ),
      ),
    );
  }
}
