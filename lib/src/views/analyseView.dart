import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:stattrack/src/business_logic/models/data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnalyseView extends StatefulWidget {
  @override
  _AnalyseViewState createState() => _AnalyseViewState();
}

class _AnalyseViewState extends State<AnalyseView> {
  String key = "";
  List<charts.Series<Entry, DateTime>> series = List.empty();
  List<String> keys = List.empty();

  _AnalyseViewState() {
    keys = Data.singleton.getNumKeys().toList();
    if (keys.isEmpty) {
      return;
    }
    key = keys[0];
    series = _convertToChart(Data.singleton.entries, key);
  }

  @override
  Widget build(BuildContext context) {
    if (keys.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.no_fields));
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      children: [
        Center(
            child: DropdownButton<String>(
                value: key,
                items: keys.map<DropdownMenuItem<String>>((String tempKey) {
                  return DropdownMenuItem<String>(
                    value: tempKey,
                    child: Text(tempKey),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    key = newValue!;
                    print("key is " + key);
                    series = _convertToChart(Data.singleton.entries, key);
                  });
                })),
        Container(
            padding: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height / 3,
            child: charts.TimeSeriesChart(
              series,
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
            ))
      ],
    );
  }

  static List<charts.Series<Entry, DateTime>> _convertToChart(
      List<Entry> entries, String key) {
    print("Looking up for " + key);
    return [
      new charts.Series<Entry, DateTime>(
          id: 'History',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Entry entry, _) => entry.date,
          measureFn: (Entry entry, _) => entry.fields[key] as num,
          data: entries)
    ];
  }
}
