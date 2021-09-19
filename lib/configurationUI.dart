import 'package:flutter/material.dart';
import 'package:stattrack/configuration.dart';

class ConfigurationUI extends StatefulWidget {
  final Configuration config;

  ConfigurationUI(this.config);

  @override
  _ConfigurationUIState createState() => _ConfigurationUIState(config);
}

class _ConfigurationUIState extends State<ConfigurationUI> {
  final Configuration config;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _ConfigurationUIState(this.config);

  void _addField(String name){
    setState(() {
      config.addField(name);
      Configuration.writeConfiguration(config);

    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: config.fields.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a stat to track',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addField("input"); //TODO get input from the form
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ));
        } else {
          return Container(
            height: 50,
            child: Text('${config.fields[index - 1].name}'),
          );
        }
      },
    );
  }
}
