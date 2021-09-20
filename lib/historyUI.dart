import 'package:flutter/material.dart';
import 'package:stattrack/data.dart';
import 'package:intl/intl.dart';

class HistoryUI extends StatelessWidget {
  final hourFormat = DateFormat.Hm();
  final dateFormat = DateFormat.yMEd();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Data.singleton.entries.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(
                  dateFormat.format(Data.singleton.entries[index].date) +
                      " - " +
                      hourFormat.format(Data.singleton.entries[index].date)),
              onTap: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: Text(hourFormat
                            .format(Data.singleton.entries[index].date)),
                        content: Container(
                          height: 300,
                          width: 300,
                          child: ListView.builder(
                            itemCount:
                                Data.singleton.entries[index].fields.length,
                            itemBuilder:
                                (BuildContext context, int nestedIndex) {
                              List<String> rows = Data
                                  .singleton.entries[index].fields.entries
                                  .map((e) => e.key + ": " + e.value.toString())
                                  .toList();
                              return ListTile(
                                title: Text(rows[nestedIndex]),
                              );
                            },
                          ),
                        ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Close'),
                          child: const Text('Close'),
                        )
                      ]
                    ));
              });
        });
  }
}
