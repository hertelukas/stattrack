import 'package:flutter/material.dart';
import 'package:stattrack/configuration.dart';
import 'package:stattrack/configurationUI.dart';
import 'package:stattrack/trackerUI.dart';
import 'package:stattrack/historyUI.dart';
import 'package:stattrack/data.dart';
import 'package:share_plus/share_plus.dart';

final Map<int, Color> color = {
  50: Color.fromRGBO(4, 131, 184, .1),
  100: Color.fromRGBO(4, 131, 184, .2),
  200: Color.fromRGBO(4, 131, 184, .3),
  300: Color.fromRGBO(4, 131, 184, .4),
  400: Color.fromRGBO(4, 131, 184, .5),
  500: Color.fromRGBO(4, 131, 184, .6),
  600: Color.fromRGBO(4, 131, 184, .7),
  700: Color.fromRGBO(4, 131, 184, .8),
  800: Color.fromRGBO(4, 131, 184, .9),
  900: Color.fromRGBO(4, 131, 184, 1),
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isShowingConfig = false;
  bool _isShowingHistory = false;

  late Configuration _config = new Configuration.empty();

  void _showConfig(bool show) {
    setState(() {
      _isShowingConfig = show;
    });
  }

  void _showHistory(bool show) {
    setState(() {
      _isShowingHistory = show;
    });
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

  MaterialColor main = MaterialColor(0xff28AFB0, color);
  MaterialColor dark = MaterialColor(0xff30343F, color);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Building app");
    print("Fields: " + _config.fields.length.toString());
    return MaterialApp(
        title: 'Stat Track',
        theme: ThemeData(primarySwatch: main),
        home: Builder(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: _isShowingConfig
                    ? Text('Configuration')
                    : _isShowingHistory
                        ? Text('History')
                        : Text('Track'),
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
                      child: Text('Hello!'),
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
                        _showConfig(false);
                        _showHistory(false);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Configure'),
                      onTap: () {
                        _showHistory(false);
                        _showConfig(true);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                        title: const Text('History'),
                        onTap: () {
                          _showConfig(false);
                          _showHistory(true);
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
              body: _isShowingConfig
                  ? ConfigurationUI(_config)
                  : _isShowingHistory
                      ? HistoryUI()
                      : FutureBuilder(
                          future: Configuration.readConfig().then((value) {
                            _config = value;
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return TrackerUI(_config);
                            } else if (snapshot.hasError) {
                              return Center(child: Text("Could not load data"));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })),
        ));
  }
}
