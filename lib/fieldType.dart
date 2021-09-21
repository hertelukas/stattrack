import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fieldType.g.dart';

@JsonSerializable()
class FieldType {
  // Static types of fields
  static FieldType text = FieldType("Text", 0);
  static FieldType checkbox = FieldType("Checkbox", 1);
  static FieldType slider = FieldType("Slider", 2);

  static List<FieldType> values() {
    List<FieldType> values = List<FieldType>.empty(growable: true);
    values.add(text);
    values.add(checkbox);
    values.add(slider);

    return values;
  }

  // JSON
  factory FieldType.fromJson(Map<String, dynamic> json) =>
      _$FieldTypeFromJson(json);

  Map<String, dynamic> toJson() => _$FieldTypeToJson(this);

  // Fields
  final String name;

  final int id;

  FieldType(this.name, this.id);

  Widget getVisualRepresentation(Map<String, Object> fields, String name) {
    return _CustomInput(fields, name, this);
  }
}

class _CustomInput extends StatefulWidget {
  final String name;
  final Map<String, Object> fields;
  final FieldType type;

  const _CustomInput(this.fields, this.name, this.type, {Key? key})
      : super(key: key);

  @override
  _CustomInputState createState() => _CustomInputState(name, type);
}

class _CustomInputState extends State<_CustomInput> {
  final String name;
  final FieldType type;
  final controller = TextEditingController();

  _CustomInputState(this.name, this.type);

  bool isChecked = false;
  double sliderValue = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Text
    if (type.id == FieldType.text.id) {
      // Set default entry
      this.widget.fields[name] = "";
      return TextField(
        decoration: InputDecoration(hintText: 'Text'),
        controller: controller,
        onChanged: (String value) {
          this.widget.fields[name] = value;
        },
      );
    }

    // Checkbox
    if (type.id == FieldType.checkbox.id) {
      // Set default entry
      this.widget.fields[name] = isChecked;

      return Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
              this.widget.fields[name] = isChecked;
            });
          });
    }

    // Slider
    if (type.id == FieldType.slider.id) {
      // Set default entry
      this.widget.fields[name] = sliderValue;

      return Slider(
        value: sliderValue,
        min: 0,
        max: 10,
        divisions: 10,
        onChanged: (double value) {
          setState(() {
            sliderValue = value;
            this.widget.fields[name] = value;
          });
        },
      );
    }

    // Error message
    return Text("Field type not found.");
  }
}
