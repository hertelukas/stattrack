import 'package:flutter/material.dart';
import 'package:stattrack/configuration.dart';
import 'package:stattrack/configurationUI.dart';
import 'package:stattrack/trackerUI.dart';
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

  Configuration _config = new Configuration.empty();

  void _showConfig(bool show) {
    setState(() {
      _isShowingConfig = show;
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
    Configuration.readConfig().then((value) {
      setState(() {
        _config = value;
      });
    });
  }

  MaterialColor main = MaterialColor(0xff28AFB0, color);
  MaterialColor dark = MaterialColor(0xff30343F, color);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Stat Track',
        theme: ThemeData(primarySwatch: main),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: _isShowingConfig ? Text('Configuration') : Text('Track'),
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
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Configure'),
                    onTap: () {
                      _showConfig(true);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            body: _isShowingConfig
                ? ConfigurationUI(_config)
                : TrackerUI(_config),
          ),
        ));
  }
}
