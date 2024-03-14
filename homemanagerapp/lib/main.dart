// main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'home_page.dart'; // Import the home_page.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Login Page',
              theme: ThemeData(
                primarySwatch: Colors.grey,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: HomePage(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Login Page',
              theme: ThemeData(
                primarySwatch: Colors.grey,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: LoginPage(),
            );
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}
