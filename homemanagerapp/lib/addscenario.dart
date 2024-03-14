import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:homemanagerapp/colors.dart';
import 'package:homemanagerapp/paths.dart';

class AddScenePage extends StatefulWidget {
  const AddScenePage({super.key});

  @override
  State<AddScenePage> createState() => _AddScenePageState();
}

class _AddScenePageState extends State<AddScenePage> {
  bool exectimeam = false;
  bool endtimeam = false;
  bool confirmpage = false;
  TimeOfDay activationtime = TimeOfDay.now();
  TimeOfDay deactivationtime = TimeOfDay.now();
  TextEditingController _namecontroller = new TextEditingController();
  List userIds = [];
  bool selectall = false;
  List frequency = [
    {
      'frequency': 'Una vez',
      'accept': false,
    },
    {
      'frequency': 'Diariamente',
      'accept': false,
    },
    {
      'frequency': 'Semanalmente',
      'accept': false,
    },
    {
      'frequency': 'Mensualmente',
      'accept': false,
    },
  ];

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection("secondary_users")
        .snapshots();
  }

  Future<TimeOfDay> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      print(picked.format(context));
    }
    return picked!;
  }

  void AddUser(String id) {
    if (userIds.contains(id)) {
      userIds.remove(id);
    } else {
      userIds.add(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text('Acceso de un usuario'),
            ),
            body: Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre del escenario',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(),
                          child: ClipRRect(
                            child: TextFormField(
                              controller: _namecontroller,
                              textAlignVertical: TextAlignVertical.center,
                              cursorHeight: 20,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: size.width * 0.6,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Usuarios',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'seleccionar todos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Checkbox(
                                      activeColor: Colors.green,
                                      value: selectall,
                                      onChanged: (value) {
                                        // setState(() {
                                        //   selectall = value!;
                                        //   for (var i = 0; i < users.length; i++) {
                                        //     users[i]['accept'] = value;
                                        //   }
                                        // });
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          height: size.width * 0.5,
                          child: StreamBuilder(
                              stream: fetchUsersAsStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                if (snapshot.hasError) {
                                  return Container();
                                }
                                List users = snapshot.data!.docs;
                                return ListView.builder(
                                  itemCount: users.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                                activeColor: Colors.green,
                                                value: userIds.contains(
                                                    users[index]['user_id']),
                                                onChanged: (value) {
                                                  print(
                                                      '${userIds.contains(users[index]['user_id'])}');
                                                  setState(() {
                                                    userIds.contains(
                                                            users[index]
                                                                ['user_id'])
                                                        ? {
                                                            userIds.remove(
                                                                users[index][
                                                                    'user_id']),
                                                            print(
                                                                "removed ${users[index]['user_id']}")
                                                          }
                                                        : {
                                                            userIds.add(users[
                                                                    index]
                                                                ['user_id']),
                                                            print(
                                                                "added ${users[index]['user_id']}")
                                                          };
                                                  });
                                                }),
                                            Text(
                                              users[index]['nickname'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_sharp,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Hora de ejecución",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                selectTime(context).then((value) {
                                  setState(() {
                                    activationtime = value;
                                  });
                                });
                              },
                              child: Text(
                                activationtime.format(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  exectimeam = !exectimeam;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: exectimeam
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        " AM ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: exectimeam
                                              ? Colors.white
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: exectimeam
                                            ? Colors.transparent
                                            : Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        " PM ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: exectimeam
                                              ? Colors.grey[700]
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Hora de término    ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                selectTime(context).then((value) {
                                  if (value.hour < activationtime.hour) {
                                    print(
                                        "not valid ${value.hour} ${activationtime.hour} ");
                                  } else if ((value.hour ==
                                          activationtime.hour &&
                                      value.minute < activationtime.minute)) {
                                    print("validdddd");
                                  } else {
                                    setState(() {
                                      deactivationtime = value;
                                    });
                                    print("valid");
                                  }
                                });
                              },
                              child: Text(
                                deactivationtime.format(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  endtimeam = !endtimeam;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: endtimeam
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        " AM ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: endtimeam
                                              ? Colors.white
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: endtimeam
                                            ? Colors.transparent
                                            : Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        " PM ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: endtimeam
                                              ? Colors.grey[700]
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: size.width * 0.6,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Repetir',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          height: size.width * 0.5,
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  List.generate(frequency.length, (index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                            activeColor: Colors.green,
                                            value: frequency[index]['accept'],
                                            onChanged: (value) {
                                              setState(() {
                                                frequency[index]['accept'] =
                                                    value!;
                                              });
                                            }),
                                        Text(
                                          frequency[index]['frequency'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            confirmpage = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: 130,
                          height: 40,
                          child: Text(
                            'Eliminar este escenario',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          try {
                            print("name : ${_namecontroller.text}");
                            print("activationtime : $activationtime");
                            print("deactivationtime : $deactivationtime");
                            print("frequency : $frequency");
                            print("userIds : $userIds");
                            FirebaseFirestore.instance
                                .collection('devices')
                                .doc(deviceId)
                                .collection('scenarios')
                                .add({
                              'name': _namecontroller.text,
                              'activationtime': activationtime.toString(),
                              'deactivationtime': deactivationtime.toString(),
                              'frequency': frequency,
                              'userIds': userIds,
                            }).then((scenarioDoc) {
                              print(
                                  "Scenario added with ID: ${scenarioDoc.id}");
                              scenarioDoc.update({
                                'scenarioId': scenarioDoc.id,
                              });
                              // Store user details as subcollection
                              for (var userId in userIds) {
                                scenarioDoc
                                    .collection('users')
                                    .doc(userId)
                                    .set({
                                  'userId': userId,
                                }).then((_) {
                                  print("User added to scenario");
                                }).catchError((error) {
                                  print(
                                      "Failed to add user to scenario: $error");
                                });
                              }

                              // Update scenario document to store user IDs

                              Navigator.pop(context);
                            }).catchError((error) {
                              print("Failed to add scenario: $error");
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          width: 130,
                          height: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Editar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          confirmpage
              ? Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      width: size.width * 0.8,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '¿Estás seguro de eliminar este escenario?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: double.infinity,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    confirmpage = false;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    // color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: 130,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Cancelar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 130,
                                height: 40,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  // color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'Eliminar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
