import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

part 'data.g.dart';

// This class represents all data saved by the user
// It can be exported as JSON
@JsonSerializable()
class Data {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    Data.path = directory.path;
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
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
  static String? path;

  List<Entry> entries;

  void addEntry(Map<String, Object> fields) {
    entries.add(Entry(DateTime.now(), fields));
    writeData(this);
    print(jsonEncode(this));
  }

  void addEntryAt(int index, Entry entry) {
    entries.insert(index, entry);
    writeData(this);
  }

  void remove(int index) {
    entries.removeAt(index);
    writeData(this);
  }

  Entry getAt(int index) {
    return entries.elementAt(index);
  }

  Data() : entries = List<Entry>.empty(growable: true);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Entry {
  DateTime date;
  Map<String, Object> fields;

  Entry(this.date, this.fields);

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);
}
