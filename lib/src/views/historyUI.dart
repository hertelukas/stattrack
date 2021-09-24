import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stattrack/src/business_logic/models/data.dart';

class HistoryUI extends StatefulWidget {
  @override
  _HistoryUIState createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> {
  final hourFormat = DateFormat.Hm();
  final dateFormat = DateFormat.yMEd();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Data.singleton.entries.length,
        itemBuilder: (BuildContext context, int index) {
          Entry entry = Data.singleton.getAt(index);
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection dir) {
                setState(() {
                  Data.singleton.remove(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Removed entry"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      setState(() {
                        Data.singleton.addEntryAt(index, entry);
                      });
                    },
                  ),
                ));
              },
              background: Container(
                color: Colors.red,
              ),
              child: ListTile(
                  title: Text(dateFormat
                          .format(Data.singleton.entries[index].date) +
                      " - " +
                      hourFormat.format(Data.singleton.entries[index].date)),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: Text(hourFormat.format(
                                    Data.singleton.entries[index].date)),
                                content: Container(
                                  height: 300,
                                  width: 300,
                                  child: ListView.builder(
                                    itemCount: Data
                                        .singleton.entries[index].fields.length,
                                    itemBuilder: (BuildContext context,
                                        int nestedIndex) {
                                      List<String> rows = Data.singleton
                                          .entries[index].fields.entries
                                          .map((e) =>
                                              e.key + ": " + e.value.toString())
                                          .toList();
                                      return ListTile(
                                        title: Text(rows[nestedIndex]),
                                      );
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Close'),
                                    child: const Text('Close'),
                                  )
                                ]));
                  }));
        });
  }
}
