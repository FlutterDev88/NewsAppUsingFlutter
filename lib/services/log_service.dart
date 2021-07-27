import 'package:flutter_application_1/models/environment_configuration.dart';

class LogService {
  static String filter = "";

  static void debug(String msg) {
    if (EnvironmentConfiguration.IS_PRODUCTION) return;
    if (msg.startsWith(filter))
      print('DEBUG: $msg');
  }

  static void error(String msg) {
    if (msg.startsWith(filter))
      print('ERROR: $msg');
  }
}