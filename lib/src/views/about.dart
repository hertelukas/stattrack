import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.about,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const Text(""),
        Text(
          AppLocalizations.of(context)!.aboutSection1,
          textAlign: TextAlign.center,
        ),
        Text(
          AppLocalizations.of(context)!.aboutSection2,
          textAlign: TextAlign.center,
        ),
        TextButton(
          child: const Text("Github"),
          onPressed: () => launch("https://github.com/hertelukas/stattrack"),
        )
      ],
    );
  }
}
