import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stattrack/src/business_logic/fieldType.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

part 'configuration.g.dart';

//This class represents and saves the
//different trackers a user added
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

  // Returns whether the field is unique. If not, the field won't get added
  bool addFieldByName(String name, FieldType type) {
    for (int i = 0; i < fields.length; i++) {
      if (fields.elementAt(i).name == name) {
        return false;
      }
    }
    addField(Field(name, type));
    return true;
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
      subtitle: type.getVisualRepresentation(fields, name),
    );
  }
}
