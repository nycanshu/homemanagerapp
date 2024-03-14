import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homemanagerapp/paths.dart';

class AlarmsScreen extends StatefulWidget {
  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  // Define the state for each alarm
  bool vibrationAlarm = false;
  bool magneticDoorAlarm = false;
  bool antiBabyAlarm = false;
  bool antiInhibitionAlarm = false;
  bool sabotageAlarmCover = false;
  bool masterAlarm = false;
  bool innerSiren = false;

  // Define the state for individual settings
  String vibrationAlarmSetting = 'Medium Sensitivity';
  String innerSirenVolume = 'Medium';
  final database = FirebaseDatabase.instance.reference();

  bool _switchValue = false;

  bool value = false;
  @override
  void initState() {
    super.initState();
  }

  List alarms = [
    {
      "path": vibration_alarm,
      'label': 'Alarma por vibración',
      'settings': vibration_alarm_sensitivity,
    },
    {
      "path": interior_siren,
      'label': 'Sirena interior',
      'settings': sirena_alarm_sensitivity,
    },
    {
      "path": antibaby_alarm,
      'label': 'Alarma antibaby',
      'settings': null,
    },
    {
      "path": anti_inhibition_alarm,
      'label': 'Alarma anti inhibición',
      'settings': null,
    },
    {
      "path": sabotage_alarm,
      'label': 'Alarma sabotaje tapa',
      'settings': null,
    },
    {
      "path": auxiliary_alarm,
      'label': 'Alarma auxiliar',
      'settings': null,
    },
    {
      "path": magnetic_door_alarm,
      'label': 'Alarma magnética puerta',
      'settings': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200, // Set background color to gray
                borderRadius: BorderRadius.circular(10.0), // Set border radius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alarmas',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Administra tus alarmas para tener más control de tu instalación',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                return CustomSwitchTile(
                  title: alarms[index]['label'],
                  databasePath: alarms[index]['path'],
                  settingspath: alarms[index]['settings'],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomSwitchTile extends StatefulWidget {
  final String title;
  final String databasePath;
  final String? settingspath;

  CustomSwitchTile({
    required this.title,
    required this.databasePath,
    this.settingspath,
  });

  @override
  _CustomSwitchTileState createState() => _CustomSwitchTileState();
}

class _CustomSwitchTileState extends State<CustomSwitchTile> {
  bool _value = false;
  final database = FirebaseDatabase.instance.reference();
  late StreamSubscription _subscription;
  late StreamSubscription _settingsSubscription;
  String _sensitivity = 'null';
  List sensitivity = ['Baja', 'Media', 'Alta'];
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialValue();
  }

  void _fetchInitialValue() {
    _subscription = database.child(widget.databasePath).onValue.listen(
      (event) {
        final data = event.snapshot.value;
        if (data != null) {
          setState(() {
            _value = data as bool;
          });
          if (_value == true) {
            print("value ${widget.title} is $_value");
          } else {
            setState(() {
              expanded = false;
            });
            print("value ${widget.title} is $_value");
          }
        }
      },
    );
    if (widget.settingspath != null && widget.settingspath!.isNotEmpty) {
      _settingsSubscription =
          database.child(widget.settingspath!).onValue.listen((event) {
        final data = event.snapshot.value;
        if (data != null) {
          setState(() {
            _sensitivity = data as String;
          });
          print("object" + _sensitivity);
        }
      });
    }
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    _subscription.cancel();
    if (widget.settingspath != null && widget.settingspath!.isNotEmpty) {
      _settingsSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CupertinoSwitch(
                        activeColor: Colors.blue,
                        value: _value,
                        onChanged: (bool newValue) {
                          print("value ${widget.title} is $newValue");
                          database
                              .child(widget.databasePath)
                              .set(newValue)
                              .then((value) {
                            print("updated ${widget.title} to $newValue");
                          });
                        },
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  (widget.settingspath != null &&
                          widget.settingspath!.isNotEmpty)
                      ? (expanded && _value)
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  expanded = false;
                                });
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  expanded = true;
                                });
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_right_sharp,
                              ),
                            )
                      : Container(),
                ],
              ),
              (expanded && _value)
                  ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(sensitivity.length, (index) {
                          return InkWell(
                            onTap: () {
                              database
                                  .child(widget.settingspath!)
                                  .set(sensitivity[index])
                                  .then((value) {
                                print(
                                    "updated ${widget.title} to $index ${sensitivity[index]} ");
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _sensitivity == sensitivity[index]
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                sensitivity[index],
                                style: TextStyle(
                                  color: _sensitivity == sensitivity[index]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
