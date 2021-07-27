import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/user_bloc.dart';
import 'package:flutter_application_1/components/scaffolded_loading_screen.dart';
import 'package:flutter_application_1/models/asset_image_paths.dart';
import 'package:flutter_application_1/views/home_screen.dart';
import 'package:flutter_application_1/views/profile_screen.dart';
import 'package:flutter_application_1/views/search_screen.dart';
import 'package:flutter_application_1/views/settings_drawer.dart';
import 'package:flutter_application_1/views/tutorial_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgets = <Widget>[
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserBloc>(builder: (context, userProvider, child) {
      return FutureBuilder<bool>(
          future: userProvider.tryInitializeUser(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return ScaffoldedLoadingScreen();
            } else {
              // if (userProvider.user == null) {
              //   return LoginScreen();
              // }

              return userProvider.isFirstLogin == true
                  ? TutorialScreen(shouldPopOnExit: false)
                  : _buildMainPage(context);
            }
          });
    });
  }

  Widget _buildMainPage(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgets,
      ),
      endDrawer: SettingsDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[900],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) { 
          setState(() {
            _selectedIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(
            activeIconPath: AssetImagePaths.home_selected, 
            iconPath: AssetImagePaths.home
          ),
          _buildBottomNavigationBarItem(
            activeIconPath: AssetImagePaths.search_selected, 
            iconPath: AssetImagePaths.search
          ),
          _buildBottomNavigationBarItem(
            activeIconPath: AssetImagePaths.profile_selected, 
            iconPath: AssetImagePaths.profile
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({String activeIconPath, String iconPath}) {
    return BottomNavigationBarItem(
      activeIcon: activeIconPath == null
       ? null
       : ImageIcon(AssetImage(activeIconPath)
      ),
      icon: ImageIcon(AssetImage(iconPath)),
      label: ''
    );
  }
}