import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homemanagerapp/addscenario.dart';
import 'package:homemanagerapp/colors.dart';
import 'package:homemanagerapp/paths.dart';

class Scenarios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Other widgets/buttons
            ScenarioButton(),
          ],
        ),
      ),
    );
  }
}

class ScenarioButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to scenarios page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScenariosPage()),
        );
      },
      child: Text('Scenario'),
    );
  }
}

class ScenariosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scenarios'),
      ),
      body: ScenariosContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new scenario
          // Implementation needed
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ScenariosContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final name = 'larson.org'; // Replace with actual scenario name

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: size.width,
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Escenarios',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Te encuentras en la instalacion $name',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AccessScenarioWidget(),
                    Divider(
                      height: 1,
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        'Apertura y cierre automáticos',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      children: [],
                    ),
                    Divider(
                      height: 1,
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Container(
                        child: Text(
                          'Cierre automático por sensor de vibración',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      children: [],
                    ),
                    Divider(
                      height: 1,
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Container(
                        child: Text(
                          'Auto cierre',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AccessScenarioWidget extends StatefulWidget {
  const AccessScenarioWidget({
    super.key,
  });

  @override
  State<AccessScenarioWidget> createState() => _AccessScenarioWidgetState();
}

class _AccessScenarioWidgetState extends State<AccessScenarioWidget> {
  List users = [];

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> fetchScenarios() {
    return FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection("scenarios")
        .snapshots();
  }

  String fetchUsers(String userId) {
    String name = "mic";
    var doc = FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection("secondary_users")
        .doc(userId)
        .get()
        .then((value) {
      name = value['nickname'];
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        childrenPadding: EdgeInsets.all(10),
        tilePadding: EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Acceso de un usuario',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        expandedAlignment: Alignment.topLeft,
        children: [
          Divider(
            height: 1,
          ),
          StreamBuilder(
              stream: fetchScenarios(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('No Scenarios found'));
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print("waiting");
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        print("erroe");
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        print("no data");
                        return Center(child: Text('No Scenarios found'));
                      }
                      List scenarios = snapshot.data!.docs;
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scenarios[index]['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 14, 132, 228),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Usuarios : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                      scenarios[index]['userIds'].length, (i) {
                                    return Text(
                                      fetchUsers(
                                          scenarios[index]['userIds'][i]),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddScenePage(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.add,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScenarioTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Scenario Name'),
      subtitle: Text('Activation Time: 10:00 AM'),
      trailing: Switch(
        value: true, // Replace with actual activation status
        onChanged: (newValue) {
          // Toggle activation status
          // Implementation needed
        },
      ),
      onTap: () {
        // Navigate to scenario details page
        // Implementation needed
      },
    );
  }
}
