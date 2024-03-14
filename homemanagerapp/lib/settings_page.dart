import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsContent extends StatefulWidget {
  @override
  _SettingsContentState createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  // Define the state for each setting
  bool sosFunction = false;
  bool smartphoneSound = false;
  bool internalSirenSound = false;
  bool auxFunctionLinking = false;
  bool smartphoneAlarm = false;
  bool beepSound = false;
  bool statusLight = false;
  bool autoClose = false;

  // Define the state for additional SOS settings
  bool additionalSosSettingsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSettingTile(
              'Función SOS',
              sosFunction,
              (value) => setState(() {
                sosFunction = value;
                // Toggle visibility of additional SOS settings
                additionalSosSettingsVisible = value;
              }),
            ),
            if (additionalSosSettingsVisible) ...[
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSettingTile2(
                      'Sonido Smartphone propio',
                      smartphoneSound,
                      (value) => setState(() => smartphoneSound = value),
                    ),
                    buildSettingTile2(
                      'Sonido sirena interior de Probulón',
                      internalSirenSound,
                      (value) => setState(() => internalSirenSound = value),
                    ),
                    buildSettingTile2(
                      'Vinculación con función AUX',
                      auxFunctionLinking,
                      (value) => setState(() => auxFunctionLinking = value),
                    ),
                  ],
                ),
              ),
            ],
            buildSettingTile(
              'Alarma en Smartphone',
              smartphoneAlarm,
              (value) => setState(() => smartphoneAlarm = value),
            ),
            buildSettingTile(
              'Sonido Bip',
              beepSound,
              (value) => setState(() => beepSound = value),
            ),
            buildSettingTile(
              'Luz de estado',
              statusLight,
              (value) => setState(() => statusLight = value),
            ),
            buildSettingTile(
              'Auto cierre',
              autoClose,
              (value) => setState(() => autoClose = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingTile(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CupertinoSwitch(
                    activeColor: Colors.blue,
                    value: value,
                    onChanged: onChanged,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}

Widget buildSettingTile2(
  String title,
  bool value,
  Function(bool) onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 8.0),
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                CupertinoSwitch(
                  activeColor: Colors.blue,
                  value: value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 8.0),
    ],
  );
}
