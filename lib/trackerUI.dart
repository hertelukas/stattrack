import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/configuration.dart';
import 'package:stattrack/fieldType.dart';
import 'package:stattrack/data.dart';

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
    } else {
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: config.fields.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < config.fields.length) {
            return _CustomRow(config.fields[index], fields);
          } else {
            return Center(
                child: ElevatedButton(
              onPressed: () {
                _save();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text("Saved entry!")));
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
}

class _CustomRow extends StatefulWidget {
  final Field field;
  final Map<String, Object> fields;

  const _CustomRow(this.field, this.fields, {Key? key}) : super(key: key);

  @override
  _CustomRowState createState() => _CustomRowState(field);
}

class _CustomRowState extends State<_CustomRow> {
  final Field field;
  final controller = TextEditingController();

  _CustomRowState(this.field);

  bool isChecked = false;
  int value = 0;
  double sliderValue = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case FieldType.text:
        return ListBody(
          children: <Widget>[
            Text(
              field.name,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4),
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Text'),
              controller: controller,
              onSubmitted: (String value) {
                this.widget.fields[field.name] = value;
              },
            )
          ],
        );
      case FieldType.boolean:
        return Row(
          children: <Widget>[
            Text(
              field.name,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4),
            ),
            Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                    this.widget.fields[field.name] = isChecked;
                  });
                })
          ],
        );
      case FieldType.slider0to10:
        return ListBody(children: <Widget>[
          Text(
            field.name,
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4),
          ),
          Slider(
            value: sliderValue,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (double value) {
              setState(() {
                sliderValue = value;
                this.widget.fields[field.name] = value;
              });
            },
          )
        ]);
    }
  }
}
