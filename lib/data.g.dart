// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data()
    ..entries = (json['entries'] as List<dynamic>)
        .map((e) => _Entry.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'entries': instance.entries,
    };

_Entry _$_EntryFromJson(Map<String, dynamic> json) {
  return _Entry(
    DateTime.parse(json['date'] as String),
    (json['fields'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, e as Object),
    ),
  );
}

Map<String, dynamic> _$_EntryToJson(_Entry instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'fields': instance.fields,
    };
