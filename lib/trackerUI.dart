import 'package:flutter/material.dart';
import 'package:stattrack/configuration.dart';
import 'package:stattrack/fieldType.dart';

class TrackerUI extends StatefulWidget {
  final Configuration config;

  TrackerUI(this.config);

  @override
  _TrackerUIState createState() => _TrackerUIState(config);
}

class _TrackerUIState extends State<TrackerUI> {
  final Configuration config;

  _TrackerUIState(this.config);

  @override
  Widget build(BuildContext context) {
    if (config.fields.isEmpty) {
      return Center(
        child: Text("Add items to track in the config menu!"),
      );
    } else {
      return ListView.builder(
          itemCount: config.fields.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < config.fields.length) {
              return _CustomRow(config.fields[index]);
            } else {
              return ElevatedButton(
                onPressed: () {},
                child: const Text("Save"),
              );
            }
          });
    }
  }
}

class _CustomRow extends StatefulWidget {
  final Field field;

  const _CustomRow(this.field, {Key? key}) : super(key: key);

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
        return Row(
          children: <Widget>[
            Text(field.name),
            Expanded(
                child: TextField(
              decoration: InputDecoration(hintText: 'Text'),
              controller: controller,
              onSubmitted: (String value) {},
            ))
          ],
        );
      case FieldType.boolean:
        return Row(
          children: <Widget>[
            Text(field.name),
            Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                })
          ],
        );
      case FieldType.slider0to10:
        return Row(children: <Widget>[
          Text(field.name),
          Slider(
            value: sliderValue,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (double value) {
              setState(() {
                sliderValue = value;
              });
            },
          )
        ]);
    }
  }
}
