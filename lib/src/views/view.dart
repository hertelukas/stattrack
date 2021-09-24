// Enum that represents all available views
enum View { Configuration, History, Tracker, About }

extension NameGenerator on View {
  // Returns the name of the view that
  // should be shown in the app bar
  String get name {
    switch (this) {
      case View.Configuration:
        return "Configuration";
      case View.History:
        return "History";
      case View.Tracker:
        return "Tracker";
      case View.About:
        return "About";
    }
  }
}
