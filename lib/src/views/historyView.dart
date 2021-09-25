import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stattrack/src/business_logic/models/data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {

  @override
  Widget build(BuildContext context) {
    DateFormat hourFormat = DateFormat.Hm(AppLocalizations.of(context)!.localeName);
    DateFormat dateFormat = DateFormat.yMEd(AppLocalizations.of(context)!.localeName);

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
                  content: Text(AppLocalizations.of(context)!.entry_removed),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context)!.undo,
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
                        builder: (BuildContext context) =>
                            AlertDialog(
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
                                        Navigator.pop(context, AppLocalizations
                                            .of(context)!.close),
                                    child: Text(AppLocalizations.of(context)!
                                        .close),
                                  )
                                ]));
                  }));
        });
  }
}
