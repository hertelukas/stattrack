import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTimeRange? timeRange;

  _AnalyseViewState() {
    keys = Data.singleton.getNumKeys().toList();
    if (keys.isEmpty) {
      return;
    }
    key = keys[0];
    series = _convertToChart(timeRange, key);
  }

  @override
  Widget build(BuildContext context) {
    if (keys.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.no_fields));
    }

    DateFormat dateFormat =
        DateFormat.yMEd(AppLocalizations.of(context)!.localeName);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          DropdownButton<String>(
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
                  series = _convertToChart(timeRange, key);
                });
              }),
          TextButton(
              onPressed: () async {
                timeRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100));
                setState(() {
                  series = _convertToChart(timeRange, key);
                });
              },
              child: Text(timeRange == null
                  ? AppLocalizations.of(context)!.set_range
                  : dateFormat.format(timeRange!.start) +
                      " - " +
                      dateFormat.format(timeRange!.end)))
        ]),
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
      DateTimeRange? range, String key) {
    List<Entry> entries;
    if (range == null) {
      entries = Data.singleton.entries;
    } else {
      entries = Data.singleton.getBetween(range.start, range.end);
    }
    return [
      new charts.Series<Entry, DateTime>(
          id: 'History',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Entry entry, _) => entry.date,
          measureFn: (Entry entry, _) {
            if (entry.fields[key] is num) {
              return entry.fields[key] as num;
            } else {
              return null;
            }
          },
          data: entries)
    ];
  }
}
