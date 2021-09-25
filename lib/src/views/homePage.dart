import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stattrack/src/business_logic/models/configuration.dart';
import 'package:stattrack/src/business_logic/models/data.dart';
import 'package:stattrack/src/views/about.dart';
import 'package:stattrack/src/views/configurationView.dart';
import 'package:stattrack/src/views/historyView.dart';
import 'package:stattrack/src/views/trackerView.dart';
import 'package:stattrack/src/views/view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        return ConfigurationView(_config);
      case View.History:
        return HistoryView();
      case View.Tracker:
        return FutureBuilder(
            future: Configuration.readConfig().then((value) {
              _config = value;
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TrackerUI(_config);
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        AppLocalizations.of(context)!.could_not_load_data));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
      case View.About:
        return AboutView();
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
    return Builder(
        builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(_currentView.getName(context)),
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
                      title: Text(AppLocalizations.of(context)!.tracker),
                      onTap: () {
                        _setView(View.Tracker);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.configure),
                      onTap: () {
                        _setView(View.Configuration);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                        title: Text(AppLocalizations.of(context)!.history),
                        onTap: () {
                          _setView(View.History);
                          Navigator.pop(context);
                        }),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.about),
                      onTap: () {
                        _setView(View.About);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
              body: _getView(),
            ));
  }
}
