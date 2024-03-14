import 'dart:async';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homemanagerapp/forgot_page.dart';
import 'package:homemanagerapp/screens/localhome.dart';

class RedLocalLogin extends StatefulWidget {
  const RedLocalLogin({super.key});

  @override
  State<RedLocalLogin> createState() => _RedLocalLoginState();
}

class _RedLocalLoginState extends State<RedLocalLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int incorrect = 0;
  bool invalid = false;
  bool _isLocked = false;
  late DateTime _unlockTime;
  Timer? _unlockTimer;
  var remainingTime = Duration();

  void _lockAccess() {
    _isLocked = true;
    _unlockTime = DateTime.now().add(Duration(minutes: 10));
    print('Access locked. Please wait for 10 minutes.');

    _unlockTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = _unlockTime.difference(DateTime.now());
      });
      if (remainingTime <= Duration()) {
        _isLocked = false;
        _cancelUnlockTimer();
        print('Access unlocked. You can try again.');
      } else {
        print(
            'Remaining time: ${remainingTime.inMinutes} minutes ${remainingTime.inSeconds.remainder(60)} seconds');
      }
    });
  }

  void _cancelUnlockTimer() {
    _unlockTimer?.cancel();
    _unlockTimer = null;
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Your logo here
                SizedBox(height: 100.0),
                FlutterLogo(
                  size: 100.0,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Red Local',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'inicie sesion con su contrasena habitual recuerde estar cerca del dispositivo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su correo electrónico';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su contraseña';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocalHomePage(),
                            ),
                          );
                          // setState(() {
                          //   incorrect++;
                          // });
                          // incorrect >= 3 ? _lockAccess() : null;
                        },
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Container(
                                width: size.width,
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'INICIAR SESIÓN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          // Navigate to the forgot password page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          '¿Olvidó su contraseña?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      incorrect > 0
                          ? Text(
                              'Intentos restantes: ${3 - incorrect}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : SizedBox.shrink(),
                      _isLocked
                          ? Text(
                              'Acceso bloqueado. Por favor espera:  ${remainingTime.inMinutes} : ${remainingTime.inSeconds.remainder(60)}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error de inicio de sesión'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
