import 'package:flutter/material.dart';
import 'package:stattrack/configuration.dart';
import 'package:stattrack/configurationUI.dart';
import 'package:stattrack/trackerUI.dart';
import 'package:stattrack/data.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Stat Track',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: _isShowingConfig ? Text('Configuration') : Text('Track'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    child: Text('Hello!'),
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
