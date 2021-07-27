import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/blocs/news_bloc.dart';
import 'package:flutter_application_1/components/scaffolded_loading_screen.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/blocs/theme_bloc.dart';
import 'package:flutter_application_1/blocs/user_bloc.dart';
import 'package:flutter_application_1/views/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ThemeData themeData;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getAppTheme = prefs.getString(kThemeLocal);
  if (getAppTheme == "Dark") {
    themeData = kThemeDataDark;
  } else {
    themeData = kThemeData;
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        child: NewsApp(),
        create: (_) => ThemeBloc(themeData),
      ),
    );
  });
}

class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  bool _isLoading = true;

  Future<void> _initialize() async {
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      _isLoading = false;        
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final themeProvider = Provider.of<ThemeBloc>(context, listen: true);

    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NewsApp',
        theme: themeProvider.getTheme(),
        home: ScaffoldedLoadingScreen(initial:true),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserBloc()),
        ChangeNotifierProvider(create: (_) => NewsBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
        theme: themeProvider.getTheme(),
        title: 'NewsApp',
      ),
    );
  }
}