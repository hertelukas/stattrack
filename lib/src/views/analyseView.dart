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
  List<charts.Series<Entry, DateTime>>? series = List.empty();
  DateTimeRange? timeRange;

  _AnalyseViewState() {
    series = _convertToChart(timeRange);
  }

  @override
  Widget build(BuildContext context) {
    if (series == null) {
      return Center(child: Text(AppLocalizations.of(context)!.no_fields));
    }

    DateFormat dateFormat =
        DateFormat.yMEd(AppLocalizations.of(context)!.localeName);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
              onPressed: () async {
                timeRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100));
                setState(() {
                  series = _convertToChart(timeRange);
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
              series!,
              animate: true,
              behaviors: [
                new charts.SeriesLegend(
                    position: charts.BehaviorPosition.bottom)
              ],
              dateTimeFactory: const charts.LocalDateTimeFactory(),
            ))
      ],
    );
  }

  static List<charts.Series<Entry, DateTime>>? _convertToChart(
      DateTimeRange? range) {
    Set<String> keys = Data.singleton.getNumKeys();
    List<Entry> entries;

    if (keys.isEmpty) {
      return null;
    }
    if (range == null) {
      entries = Data.singleton.entries;
    } else {
      entries = Data.singleton.getBetween(range.start, range.end);
    }

    List<charts.Series<Entry, DateTime>> result = List.empty(growable: true);

    int i = 0;
    for (var key in keys) {
      var temp = charts.MaterialPalette.blue.makeShades(keys.length)[i];
      result.add(new charts.Series<Entry, DateTime>(
          displayName: key,
          id: key,
          colorFn: (_, __) => temp,
          domainFn: (Entry entry, _) => entry.date,
          measureFn: (Entry entry, _) {
            if (entry.fields[key] is num) {
              return entry.fields[key] as num;
            } else {
              return null;
            }
          },
          data: entries));
      i++;
    }

    return result;
  }
}
