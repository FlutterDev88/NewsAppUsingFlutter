import 'package:flutter/material.dart';

import 'package:flutter_application_1/views/settings_drawer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Info'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: (){
              SettingsDrawer.openDrawer(context);
            }
          )
        ],
      ),
      body: Container(),
    );
  }
}