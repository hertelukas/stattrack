import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/src/business_logic/models/configuration.dart';
import 'package:stattrack/src/business_logic/models/data.dart';

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
    Data.singleton.addEntry(fields);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (config.fields.isEmpty) {
      return Center(
        child: Text("Add items to track in the config menu!"),
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
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: const Text("Saved entry!")));
            },
            child: const Text("Save"),
          ));
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
