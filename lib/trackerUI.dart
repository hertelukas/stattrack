import 'package:flutter/material.dart';
import 'package:stattrack/configurationUI.dart';

class TrackerUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Hello!'),
            ),
            ListTile(
              title: const Text('Tracker'),
              onTap: () {
                //TODO

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Configure'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfigurationUI()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
