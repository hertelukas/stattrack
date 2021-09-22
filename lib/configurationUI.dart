import 'package:flutter/material.dart';
import 'package:stattrack/configuration.dart';
import 'package:stattrack/fieldType.dart';

class ConfigurationUI extends StatefulWidget {
  final Configuration config;

  ConfigurationUI(this.config);

  @override
  _ConfigurationUIState createState() => _ConfigurationUIState(config);
}

class _ConfigurationUIState extends State<ConfigurationUI> {
  final Configuration config;

  _ConfigurationUIState(this.config);

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: config.fields.length,
          itemBuilder: (BuildContext context, int index) {
            String item = config.fields[index].name +
                " (" +
                config.fields[index].type.name +
                ")";
            Field field = config.fields[index];
            return Dismissible(
                key: Key(item),
                onDismissed: (DismissDirection dir) {
                  setState(() {
                    config.removeField(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Removed tracker"),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        setState(() {
                          config.addFieldAt(field, index);
                        });
                      },
                    ),
                  ));
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                ),
                child: ListTile(title: Text("$item")));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      _AddTrackerForm(config, this.callback),
                ));
          },
          child: const Icon(Icons.add),
        ));
  }
}

class _AddTrackerForm extends StatefulWidget {
  final Configuration config;
  final Function callback;

  _AddTrackerForm(this.config, this.callback, {Key? key}) : super(key: key);

  @override
  _AddTrackerFormState createState() => _AddTrackerFormState(config);
}

class _AddTrackerFormState extends State<_AddTrackerForm> {
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Set the default type to an integer
  FieldType dropdownValue = FieldType.text;
  final Configuration config;

  _AddTrackerFormState(this.config);

  bool _addField(String name, FieldType type) {
    bool result = true;
    setState(() {
      result = config.addFieldByName(name, type);
      //Notify the parent to update its view
      this.widget.callback();
    });

    return result;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create a new item'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Adding a new tracker"),
                    content: const Text(
                        "Add a new tracker. Use these trackers to keep track of everything you like. " +
                            "Furthermore you can use a Checkbox as filter for the analysis of your data."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Center(
                    child: DropdownButton<FieldType>(
                        value: dropdownValue,
                        items: FieldType.values()
                            .map<DropdownMenuItem<FieldType>>(
                                (FieldType value) {
                          return DropdownMenuItem<FieldType>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                        onChanged: (FieldType? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        })),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter a stat to track',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  controller: controller,
                ),
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_addField(controller.text, dropdownValue)) {
                        Navigator.pop(context);
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Provide a unique name"),
                                  content: const Text(
                                      "A tracker with this name already exists. Try a new name or delete the old tracker."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Close'),
                                      child: const Text('Close'),
                                    )
                                  ],
                                ));
                      }
                    }
                  },
                  child: const Text('Add'),
                ))
              ],
            )));
  }
}
