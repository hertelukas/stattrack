import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stattrack/fieldType.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

part 'configuration.g.dart';

@JsonSerializable()
class Configuration {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.stt');
  }

  static Future<Configuration> readConfig() async {
    try {
      final file = await _localFile;

      //Read the file
      final contents = await file.readAsString();
      return Configuration.fromJson(jsonDecode(contents));
    } catch (e) {
      return Configuration.empty();
    }
  }

  static Future<File> writeConfiguration(Configuration configuration) async {
    final file = await _localFile;

    return file.writeAsString(jsonEncode(configuration));
  }

  List<Field> fields;

  Configuration.empty() : fields = List<Field>.empty(growable: true);

  Configuration(this.fields);

  void addFieldByName(String name, FieldType type) {
    addField(Field(name, type));
  }

  void addField(Field field) {
    addFieldAt(field, fields.length);
  }

  void addFieldAt(Field field, int index) {
    fields.insert(index, field);
    writeConfiguration(this);
  }

  void removeField(int index) {
    fields.removeAt(index);
    writeConfiguration(this);
  }

  factory Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);
}

@JsonSerializable()
class Field {
  String name;
  FieldType type;

  Field(this.name, this.type);

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);

  // Returns a visual representation of the field
  // Used in the trackerUI
  Widget getWidget(Map<String, Object> fields, BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),
      ),
      subtitle: _CustomInput(this, fields),
    );
  }
}

class _CustomInput extends StatefulWidget {
  final Field field;
  final Map<String, Object> fields;

  const _CustomInput(this.field, this.fields, {Key? key}) : super(key: key);

  @override
  _CustomInputState createState() => _CustomInputState(field);
}

class _CustomInputState extends State<_CustomInput> {
  final Field field;
  final controller = TextEditingController();

  _CustomInputState(this.field);

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
        return TextField(
          decoration: InputDecoration(hintText: 'Text'),
          controller: controller,
          onChanged: (String value) {
            this.widget.fields[field.name] = value;
          },
        );
      case FieldType.boolean:
        return Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
                this.widget.fields[field.name] = isChecked;
              });
            });
      case FieldType.slider:
        return Slider(
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
        );
    }
  }
}
