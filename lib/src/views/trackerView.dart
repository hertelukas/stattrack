import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/src/business_logic/models/configuration.dart';
import 'package:stattrack/src/business_logic/models/data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackerUI extends StatefulWidget {
  final Configuration config;

  TrackerUI(this.config);

  @override
  _TrackerUIState createState() => _TrackerUIState(config);
}

class _TrackerUIState extends State<TrackerUI> {
  final Configuration config;

  _TrackerUIState(this.config) : fields = Map();

  Map<String, Object> fields;

  bool _save() {
    Data.singleton.addEntry({...fields}); // Create a copy of the fields
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (config.fields.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.empty_track_help),
      );
    }

    // If there are some fields, we return them
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: config.fields.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index < config.fields.length) {
          return config.fields[index].getWidget(fields, context);
        } else {
          return Center(
              child: ElevatedButton(
            onPressed: () {
              _save();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.saved)));
            },
            child: Text(AppLocalizations.of(context)!.save),
          ));
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
