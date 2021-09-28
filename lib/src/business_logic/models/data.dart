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

  // Returns all entries between start and end
  List<Entry> getBetween(DateTime start, DateTime end) {
    List<Entry> result = new List.empty(growable: true);
    for (var entry in entries) {
      if (entry.date.compareTo(start) >= 0 && entry.date.compareTo(end) < 0) {
        result.add(entry);
      }
    }

    return result;
  }

  // Returns all keys that hold numbers
  Set<String> getNumKeys(){
    Set<String> result = new Set();
    for (var entry in entries) {
      for (var key in entry.fields.keys) {
        if(entry.fields[key] is num){
          result.add(key);
        }
      }
    }

    return result;
  }

  Data() : entries = List<Entry>.empty(growable: true);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  @override
  String toString() {
    String result = "----------\nData: \n";
    for (var entry in entries) {
      result += entry.toString() + "\n";
    }

    return result;
  }
}

// Represents a single field
// A new instance of this class gets created when the user clicks 'save'
@JsonSerializable()
class Entry {
  DateTime date;
  Map<String, Object> fields;

  Entry(this.date, this.fields);

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);

  @override
  String toString() {
    return date.toString() + ": " + fields.toString();
  }
}
