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

  static Future<Data> readData() async {
    try {
      final file = await _localFile;

      //Read the file
      final contents = await file.readAsString();
      return Data.fromJson(jsonDecode(contents));
    } catch (e) {
      return Data();
    }
  }

  static Future<File> writeData(Data data) async {
    final file = await _localFile;

    return file.writeAsString(jsonEncode(data));
  }

  static String getAsString(Data data) {
    return jsonEncode(data);
  }

  static Data singleton = Data();

  List<_Entry> entries;

  void addEntry(Map<String, Object> fields) {
    entries.add(_Entry(DateTime.now(), fields));
    writeData(this);
    print(jsonEncode(this));
  }

  Data() : entries = List<_Entry>.empty(growable: true);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class _Entry {
  DateTime date;
  Map<String, Object> fields;

  _Entry(this.date, this.fields);

  factory _Entry.fromJson(Map<String, dynamic> json) => _$_EntryFromJson(json);

  Map<String, dynamic> toJson() => _$_EntryToJson(this);
}
