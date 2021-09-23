import 'package:flutter/material.dart';
import 'package:stattrack/about.dart';
import 'package:stattrack/configuration.dart';
import 'package:stattrack/configurationUI.dart';
import 'package:stattrack/trackerUI.dart';
import 'package:stattrack/historyUI.dart';
import 'package:stattrack/data.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';

import 'package:stattrack/view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  View _currentView = View.Tracker;

  late Configuration _config = new Configuration.empty();

  void _setView(View view) {
    setState(() {
      _currentView = view;
    });
  }

  Widget _getView() {
    switch (_currentView) {
      case View.Configuration:
        return ConfigurationUI(_config);
      case View.History:
        return HistoryUI();
      case View.Tracker:
        return FutureBuilder(
            future: Configuration.readConfig().then((value) {
              _config = value;
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TrackerUI(_config);
              } else if (snapshot.hasError) {
                return Center(child: Text("Could not load data"));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
      case View.About:
        return AboutUI();
    }
  }

  @override
  void initState() {
    super.initState();
    Data.readData().then((value) {
      setState(() {
        Data.singleton = value;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Building app");
    print("Fields: " + _config.fields.length.toString());
    return MaterialApp(
        title: 'Stat Track',
        theme:
            ThemeData(primarySwatch: generateMaterialColor(Color(0xff28AFB0))),
        home: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(_currentView.name),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          Share.shareFiles(['${Data.path}/data.json']);
                        },
                      )
                    ],
                  ),
                  drawer: Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const DrawerHeader(
                          child: Text(''),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                Color.fromARGB(255, 40, 175, 176),
                                Color.fromARGB(255, 48, 52, 63)
                              ])),
                        ),
                        ListTile(
                          title: const Text('Tracker'),
                          onTap: () {
                            _setView(View.Tracker);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Configure'),
                          onTap: () {
                            _setView(View.Configuration);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                            title: const Text('History'),
                            onTap: () {
                              _setView(View.History);
                              Navigator.pop(context);
                            }),
                        ListTile(
                          title: const Text('About'),
                          onTap: () {
                            _setView(View.About);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  body: _getView(),
                )));
  }

  // Source: https://gist.github.com/moritzmorgenroth/5602102d855efde2d686b0c7c5a095ad
  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}
