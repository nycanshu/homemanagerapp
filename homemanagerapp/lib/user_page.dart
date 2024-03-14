import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserProfileScreen(),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _aliasController = TextEditingController();
  TextEditingController _primaryEmailController = TextEditingController();
  TextEditingController _secondaryEmailController = TextEditingController();

  UserModel user = UserModel(
    alias: 'Miranda',
    primaryEmail: 'hi@gmail.com',
    secondaryEmail: 'hi2@gmail.com',
    darkMode: false,
    subscriptionStatus: 'active',
  );

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _aliasController.text = user.alias;
    _primaryEmailController.text = user.primaryEmail ?? '';
    _secondaryEmailController.text = user.secondaryEmail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopContainer(),
            _buildProfileCard(),
            if (isEditing) _buildEditSection(),
            SizedBox(height: 16.0),
            Text(
              'Subscription Status: ${user.subscriptionStatus}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Mi Perfil',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage(
                'assets/user_image.jpg'), // Replace with your image path
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableTile('Alías', _aliasController, isEditing),
            Divider(),
            _buildEditableTile(
              'Correo electrónico principal',
              _primaryEmailController,
              isEditing,
            ),
            Divider(),
            _buildEditableTile(
              'Correo electrónico secundario',
              _secondaryEmailController,
              isEditing,
            ),
            Divider(),
            ListTile(
              title: Text(
                'Modo',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.darkMode ? 'Oscuro' : 'Claro',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            if (!isEditing) _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTile(
      String title, TextEditingController controller, bool isEditing) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      subtitle: isEditing
          ? TextFormField(
              controller: controller,
              style: TextStyle(fontSize: 16.0),
            )
          : Text(
              controller.text,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildEditButton() {
    return Row(
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
            child: Text('Edit'),
          ),
        ),
      ],
    );
  }

  Widget _buildEditSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16.0),
        Text(
          'Are you sure you want to save changes?',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.0),
        Container(
          width: 200.0, // Adjust the width as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  _saveChanges();
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
    setState(() {
      isEditing = false;
      user.alias = _aliasController.text;
      user.primaryEmail = _primaryEmailController.text;
      user.secondaryEmail = _secondaryEmailController.text;
    });
  }
}

class UserModel {
  String alias;
  String primaryEmail;
  String? secondaryEmail;
  bool darkMode;
  String subscriptionStatus;

  UserModel({
    required this.alias,
    required this.primaryEmail,
    required this.darkMode,
    required this.subscriptionStatus,
    this.secondaryEmail,
  });
}
