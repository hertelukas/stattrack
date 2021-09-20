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
            String item = config.fields[index].name + " (" + config.fields[index].type.name + ")";
            return Dismissible(
              key: Key(item),
              onDismissed: (DismissDirection dir){
                setState(() {
                  config.removeField(index);
                });
              },
              background: Container(
                child: Icon(Icons.delete),
                color: Colors.red,
                alignment: Alignment.centerLeft,
              ),
              child: ListTile(
                title: Text("$item")
              )
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => _AddTrackerForm(config, this.callback),
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
  FieldType dropdownValue = FieldType.integer;
  final Configuration config;

  _AddTrackerFormState(this.config);

  void _addField(String name, FieldType type) {
    setState(() {
      config.addField(name, type);
      //Notify the parent to update its view
      this.widget.callback();
    });
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
          title: const Text('Create a new Item'),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: [
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
                DropdownButton<FieldType>(
                    value: dropdownValue,
                    items: FieldType.values
                        .map<DropdownMenuItem<FieldType>>((FieldType value) {
                      return DropdownMenuItem<FieldType>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (FieldType? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    }),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addField(controller.text, dropdownValue);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                )
              ],
            )));
  }
}
