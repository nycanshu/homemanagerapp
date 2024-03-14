// home_page.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'alarms_content.dart';
import 'scenarios_content.dart';
import 'notifications_content.dart';
import 'user_page.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  // bool activated = false;
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final database = FirebaseDatabase.instance.reference();

  bool _switchValue = false;
  void fetchDeviceIds() {
    FirebaseFirestore.instance
        .collection('devices')
        .where('main_user', isEqualTo: uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.id);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDeviceIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                'Welcome ${userEmail} ',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 14, 132, 228),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "larson.org ",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ' Activated',
                  ),
                ),
              );

              // _toggleSwitch(!_switchValue);
            },
            child: Container(
              height: 25,
              width: 100,
              decoration: BoxDecoration(
                color: _switchValue ? Colors.green[100] : Colors.grey[600],
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                "activado",
                style: TextStyle(
                  fontSize: 14,
                  color: _switchValue ? Colors.green : Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification Clicked'),
                ),
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(
          userEmail: (userEmail! ?? "")), // Use the MyDrawer widget here
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        useLegacyColorScheme: false,
        enableFeedback: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        showSelectedLabels: true, // Show labels always
        unselectedItemColor: Colors.grey, // Set the color for unselected icons
        selectedItemColor: Colors.blue, // Set the color for selected icons
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedFontSize: 12,
        unselectedIconTheme: IconThemeData(
          size: 35,
        ),
        selectedIconTheme: IconThemeData(
          size: 35,
        ),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.report_problem_outlined,
              size: 35,
            ),
            label: 'Alarmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              size: 35,
            ),
            label: 'Escenarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              size: 35,
            ),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.play_circle_fill,
              size: 35,
            ),
            label: 'Inicio',
          ),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return AlarmsScreen();
      case 1:
        return ScenariosContent();
      case 2:
        return NotificationsContent();
      case 3:
        return FourButtonsScreen();
      default:
        return Container();
    }
  }
}

class FourButtonsScreen extends StatefulWidget {
  @override
  State<FourButtonsScreen> createState() => _FourButtonsScreenState();
}

class _FourButtonsScreenState extends State<FourButtonsScreen> {
  bool par = false;
  bool sos = false;
  bool aux = false;
  bool parar = false;
  bool activated = false;
  var database = FirebaseDatabase.instance.reference();
  late StreamSubscription _subscriptions;

  void fetchvalues() {
    _subscriptions =
        database.child('d1234').child("SOS").onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          sos = data as bool;
        });
      }

      print(event.snapshot.value);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            par = !par;
                          });
                          database.child('d1234').update({
                            'par': par,
                          });

                          // Add functionality for button 1
                          print('par value is $par');
                        },
                        child: Container(
                          height: 250,
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50),
                          decoration: BoxDecoration(
                            // color: Colors.black,
                            border: Border(
                              right: BorderSide(
                                color:
                                    Colors.grey, // Set the color of the border
                                width: 3.0, // Set the width of the border
                              ),
                              bottom: BorderSide(
                                color:
                                    Colors.grey, // Set the color of the border
                                width: 3.0, // Set the width of the border
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: par ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'PAR',
                              style: TextStyle(
                                fontSize: 28, // Set the font size
                                color: par
                                    ? Colors.white
                                    : Colors
                                        .black, // Set the color to dark gray
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            sos = !sos;
                          });
                          database.child('d1234').update({
                            'sos': sos,
                          });
                          // Add functionality for button 1
                          print('Sos value is $sos');
                        },
                        child: Container(
                          height: 250,
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    Colors.grey, // Set the color of the border
                                width: 3.0, // Set the width of the border
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: sos ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'SOS',
                              style: TextStyle(
                                fontSize: 28, // Set the font size
                                color: sos
                                    ? Colors.white
                                    : Colors
                                        .black, // Set the color to dark gray
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            aux = !aux;
                          });
                          database.child('d1234').update({'aux': aux});

                          // Add functionality for button 1
                          print('aux value is now $aux');
                        },
                        child: Container(
                          height: 250,
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color:
                                    Colors.grey, // Set the color of the border
                                width: 3.0, // Set the width of the border
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: aux ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'AUX',
                              style: TextStyle(
                                fontSize: 28, // Set the font size
                                color: aux
                                    ? Colors.white
                                    : Colors
                                        .black, // Set the color to dark gray
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            parar = !parar;
                          });
                          database.child('d1234').update({
                            'parar': parar,
                          });
                          print('Button 1 clicked');
                        },
                        child: Container(
                          height: 250,
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: parar ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'PARAR',
                              style: TextStyle(
                                fontSize: 28, // Set the font size
                                color: parar
                                    ? Colors.white
                                    : Colors
                                        .black, // Set the color to dark gray
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // Add functionality for center button
                    setState(() {
                      activated = !activated;
                    });
                    database.child('d1234').update(
                      {
                        'central_lock': activated,
                      },
                    );
                    print('Center button clicked');
                  },
                  child: Container(
                    height: size.width * 0.5,
                    width: size.width * 0.5,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      activated
                          ? 'assets/images/lockedblue.png'
                          : "assets/images/unlockedgrey.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
