import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

part 'data.g.dart';

@JsonSerializable()
class Data {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.stt');
  }

  static Future<Data> readConfig() async {
    try {
      final file = await _localFile;

      //Read the file
      final contents = await file.readAsString();
      return Data.fromJson(jsonDecode(contents));
    } catch (e) {
      return Data();
    }
  }

  static Future<File> writeConfiguration(Data data) async {
    final file = await _localFile;

    return file.writeAsString(jsonEncode(data));
  }

  static String getAsString(Data data) {
    return jsonEncode(data);
  }

  List<_Entry> entries;

  Data() : entries = List<_Entry>.empty(growable: true);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class _Entry {
  DateTime date;
  Map<String, Object> fields;

  _Entry(this.date, this.fields);
}
