enum View { Configuration, History, Tracker, About }

extension NameGenerator on View {
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
