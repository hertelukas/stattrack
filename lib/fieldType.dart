enum FieldType { text, boolean, slider }

extension GetExtension on FieldType {
  String get name {
    switch (this) {
      case FieldType.text:
        return "Text";
      case FieldType.boolean:
        return "Checkbox";
      case FieldType.slider:
        return "Slider";
    }
  }
}