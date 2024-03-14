import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTitle(title: 'Revisión de estado', isBold: true, isBig: true),
            CustomStatusTile(
                name: 'Estado de conexión', status: 'Sin conexión'),
            CustomStatusTile(name: 'Estado de batería', status: 'Toma '),
            CustomStatusTile(
                name: 'Estado sensor de puerta (MP)', status: 'Abierto'),
            CustomStatusTile(name: 'Estado de Probulon', status: 'Armado'),
            CustomStatusTile(name: 'Sensor de vibración', status: 'Activado'),
            CustomStatusTile(
                name: 'Sensor anti-sabotaje', status: '+ Operativo'),
          ],
        ),
      ),
    );
  }
}

class CustomStatusTile extends StatelessWidget {
  final String name;
  final String status;

  CustomStatusTile({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Gray background color
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(status),
        ],
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  final String title;
  final bool isBold;
  final bool isBig;

  CustomTitle({required this.title, this.isBold = false, this.isBig = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Gray background color
      margin: EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: isBig ? 20 : 16,
        ),
      ),
    );
  }
}
