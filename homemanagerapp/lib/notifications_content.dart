import 'package:flutter/material.dart';

class NotificationsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 30.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Notificaciones',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Las notificaciones se eliminarán automáticamente del sistema desde su fecha de entrada',
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildNotificationItem('Alarmas', 'Notificaciones no leídas'),
          _buildNotificationItem('1 Usos', 'Notificaciones no leídas'),
          _buildNotificationItem('Incidencias', 'Notificaciones no leídas'),
          _buildNotificationItem('Administrativas', 'Notificaciones no leídas'),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.grey.withOpacity(0.2),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
