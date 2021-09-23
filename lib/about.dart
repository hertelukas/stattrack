import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        const Text(
          "About",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const Text(""),
        const Text(
          "You can track everything you want with this app. Just select \"Configure\" and tap the plus sign. " +
              "Choose your names wisely, mixing data types can result in issues when analysing the data.",
          textAlign: TextAlign.center,
        ),
        const Text(
            "Stat Track is open source! If you have any wishes or suggestions, just open a new issue on Github.",
          textAlign: TextAlign.center,
        ),
        TextButton(
          child: const Text("Github"),
          onPressed: () => launch("https://github.com/hertelukas/stattrack"),
        ),
        TextButton(
          child: const Text("Online Analyser"),
          onPressed: () => launch("https://stattrack.lukas-hertel.de/"),
        ),
        TextButton(
          child: const Text("Analyser Program"),
          onPressed: () => launch(
              "https://github.com/hertelukas/stattrack-analyser/releases"),
        )
      ],
    );
  }
}
