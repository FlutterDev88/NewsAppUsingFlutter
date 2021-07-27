import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/theme_bloc.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/models/asset_image_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDrawer extends StatefulWidget {
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();

  static void openDrawer(BuildContext context) {
    final scaffoldState = context.findAncestorStateOfType<ScaffoldState>();
    if(scaffoldState != null) {
      scaffoldState.openEndDrawer();
    }
  }
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  String getAppTheme;
  bool isTheme = true;

  @override
  void initState() {
    super.initState();
    getAppThemeData();
  }

  void getAppThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      getAppTheme = prefs.getString(kThemeLocal);
      if (getAppTheme == null) {
        getAppTheme = "Light";
        isTheme = true;
      } else if (getAppTheme == "Light") {
        isTheme = true;
      } else {
        isTheme = false;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeBloc>(context, listen: false);

    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(''),
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AssetImagePaths.avatar1),
                  fit: BoxFit.scaleDown,
                ),
              ),
            )
          ),
          Container (
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('App Version'),
                  onTap:(){
                    //
                  }
                ),
                ListTile(
                  leading: Icon(Icons.account_tree),
                  title: Text(
                    isTheme 
                      ? 'App Theme -> Light' 
                      : 'App Theme -> Dark'
                  ),
                  onTap:(){
                    setState(() {
                      themeProvider.setTheme(
                        getAppTheme == 'Light'
                            ? 'Dark'
                            : 'Light',
                      );
                      isTheme = !isTheme;
                      if (isTheme) {
                        getAppTheme = 'Light';
                      }
                      else {
                        getAppTheme = 'Dark';
                      }
                    });
                  }
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap:(){
                    //
                  }
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}