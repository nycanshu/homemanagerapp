// drawer.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'status_page.dart';
import 'user_page.dart';
import 'settings_page.dart';
import 'help_page.dart';
import 'notifications_content.dart';
import 'users.dart';

class MyDrawer extends StatelessWidget {
  final String userEmail;

  MyDrawer({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '¡Hola $userEmail!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_circle, size: 32),
              title: Text(
                'Mi Perfil',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, size: 32),
              title: Text(
                'Instalaciones',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle 'Instalaciones' tap
              },
            ),
            ListTile(
              leading: Icon(Icons.verified, size: 32),
              title: Text(
                'Revisión de estado',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatusPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people, size: 32),
              title: Text(
                'Usuarios',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month, size: 32),
              title: Text(
                'Escenarios',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle 'Escenarios' tap
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, size: 32),
              title: Text(
                'Notificaciones',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsContent()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, size: 32),
              title: Text(
                'Ajustes',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsContent()),
                );
              },
            ),
            // Divider above 'Cerrar sesión'
            ListTile(
              leading: Icon(Icons.help, size: 32),
              title: Text(
                'Ayuda',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, size: 32),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () async {
                Navigator.pop(context); // Close the drawer

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                          "¿Estás seguro de cerrar sesión en este dispositivo?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            try {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            } catch (e) {
                              print("Error signing out: $e");
                            }
                          },
                          child: Text("Sí, continuar"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text("Cancelar"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
