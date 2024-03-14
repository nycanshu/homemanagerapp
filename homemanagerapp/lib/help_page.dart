import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centro de Ayuda'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                // Replace this with your code to download instructions PDF
                // You may use packages like `url_launcher` or `path_provider` for this
              },
              icon: Icon(Icons.download),
              label: Text('Descargar instrucciones en PDF'),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cuéntanos cómo podemos ayudarte',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle sending the message
              },
              child: Text('Enviar'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Para adjuntar archivos, contacte con nosotros en el correo: probulón@gmail.com',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
