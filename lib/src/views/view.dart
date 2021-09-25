import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Enum that represents all available views
enum View { Configuration, History, Tracker, About }

extension NameGenerator on View {
  // Returns the name of the view that
  // should be shown in the app bar
  String getName(BuildContext context) {
    switch (this) {
      case View.Configuration:
        return AppLocalizations.of(context)!.configure;
      case View.History:
        return AppLocalizations.of(context)!.history;
      case View.Tracker:
        return AppLocalizations.of(context)!.tracker;
      case View.About:
        return AppLocalizations.of(context)!.about;
    }
  }
}
