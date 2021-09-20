enum FieldType { text, boolean, slider0to10 }

extension NameExtension on FieldType {
  String get name {
    switch (this) {
      case FieldType.text:
        return "Text";
      case FieldType.boolean:
        return "Checkbox";
      case FieldType.slider0to10:
        return "Slider";
    }
  }
}
