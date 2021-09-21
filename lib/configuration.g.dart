// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Configuration _$ConfigurationFromJson(Map<String, dynamic> json) {
  return Configuration(
    (json['fields'] as List<dynamic>)
        .map((e) => Field.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ConfigurationToJson(Configuration instance) =>
    <String, dynamic>{
      'fields': instance.fields,
    };

Field _$FieldFromJson(Map<String, dynamic> json) {
  return Field(
    json['name'] as String,
    FieldType.fromJson(json['type'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };
