import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LocalHomePage extends StatefulWidget {
  const LocalHomePage({super.key});

  @override
  State<LocalHomePage> createState() => _LocalHomePageState();
}

class _LocalHomePageState extends State<LocalHomePage> {
  Map<String, dynamic> data = {};
  late DatabaseReference databaseReference;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          data = Map<String, dynamic>.from(
              event.snapshot.value as Map<dynamic, dynamic>);
        });
      }
    }).catchError((error) {
      print("Error loading data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Fields'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          String key = data.keys.elementAt(index);
          dynamic value = data[key];
          return ListTile(
            title: Text(key),
            subtitle: key == 'STATUS'
                ? Text('Battery Status: ${value['battery_status']}')
                : null,
            trailing: key != 'STATUS'
                ? Switch(
                    value: value,
                    onChanged: (newValue) {
                      updateData(key, newValue);
                    },
                  )
                : null,
          );
        },
      ),
    );
  }

  void updateData(String key, bool newValue) {
    databaseReference.child(key).set(newValue);
  }
}
