// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data()
    ..entries = (json['entries'] as List<dynamic>)
        .map((e) => Entry.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'entries': instance.entries,
    };

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return Entry(
    DateTime.parse(json['date'] as String),
    (json['fields'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, e as Object),
    ),
  );
}

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'fields': instance.fields,
    };
