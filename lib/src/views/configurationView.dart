import 'package:flutter/material.dart';
import 'package:stattrack/src/business_logic/models/configuration.dart';
import 'package:stattrack/src/business_logic/fieldType.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigurationView extends StatefulWidget {
  final Configuration config;

  ConfigurationView(this.config);

  @override
  _ConfigurationViewState createState() => _ConfigurationViewState(config);
}

class _ConfigurationViewState extends State<ConfigurationView> {
  final Configuration config;

  _ConfigurationViewState(this.config);

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
                    content:
                        Text(AppLocalizations.of(context)!.removed_tracker),
                    action: SnackBarAction(
                      label: AppLocalizations.of(context)!.undo,
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
          title: Text(AppLocalizations.of(context)!.create_new_item),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title:
                        Text(AppLocalizations.of(context)!.adding_new_tracker),
                    content:
                        Text(AppLocalizations.of(context)!.add_tracker_help),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(
                            context, AppLocalizations.of(context)!.ok),
                        child: Text(AppLocalizations.of(context)!.ok),
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
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.stat_name_hint,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enter_name;
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
                                  title: Text(AppLocalizations.of(context)!.unique_name),
                                  content: Text(AppLocalizations.of(context)!.name_exists),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, AppLocalizations.of(context)!.close),
                                      child: Text(AppLocalizations.of(context)!.close),
                                    )
                                  ],
                                ));
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.add),
                ))
              ],
            )));
  }
}
