import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';

import 'package:flutter_application_1/models/environment_configuration.dart';
import 'package:flutter_application_1/models/exceptions.dart';
import 'package:flutter_application_1/models/shared_preference_keys.dart';
import 'package:flutter_application_1/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final url = '${EnvironmentConfiguration.BASE_API_URL}/pub/login';
    final body = {'email': email, 'password': password};
    final response = await HttpService.post(url, body, false);
    final responseBody = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            SharedPreferenceKeys.TOKEN, responseBody['result']['token']);
        return true;
      case 401:
        return Future.error(UnauthorizedException(responseBody['error']));
      default:
        return Future.error(BadRequestException(responseBody['error']));
    }
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceKeys.TOKEN);
  }

  static Future<dynamic> register(String email, String password, String name,
      String phone, String avatar) async {
    final url = '${EnvironmentConfiguration.BASE_API_URL}/pub/register';
    final body = {
      'avatar': avatar,
      'email': email,
      'name': name,
      'password': password,
      'phone': (phone == null || phone.isEmpty)
          ? null
          : (phone.startsWith('+') ? phone : '+$phone'),
      'theme': 'light',
      'deviceId': ''
    };

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      body['deviceId'] = iosDeviceInfo.identifierForVendor;
    } else {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      body['deviceId'] = androidDeviceInfo.androidId;
    }

    final response = await HttpService.post(url, body, false);

    return HttpService.parseResponse(response);
  }

  static Future<dynamic> update(String email, String password, String name,
      String phone, String avatar, String theme) async {
    print("phone $phone");
    final url = '${EnvironmentConfiguration.BASE_API_URL}/builder';
    final body = {
      'avatar': avatar,
      'builderName': name,
      'email': email,
      'password': password,
      'phone': (phone == null || phone.isEmpty)
          ? ""
          : (phone.startsWith('+') ? phone : '+$phone'),
      'theme': theme.toLowerCase()
    };

    final response = await HttpService.put(url, body);

    return HttpService.parseResponse(response);
  }

  static Future<dynamic> verify(String email, String code) async {
    final url = '${EnvironmentConfiguration.BASE_API_URL}/pub/verify';
    final body = {'email': email, 'code': code};

    final response = await HttpService.post(url, body, false);

    return HttpService.parseResponse(response);
  }

  static Future<dynamic> resendVerification(String email) async {
    final url = '${EnvironmentConfiguration.BASE_API_URL}/pub/resend';
    final body = {'email': email};

    final response = await HttpService.post(url, body, false);

    return HttpService.parseResponse(response);
  }

  static Future<dynamic> forgotPassword(String email) async {
    final url = '${EnvironmentConfiguration.BASE_API_URL}/pub/forgot';
    final body = {'email': email};

    final response = await HttpService.post(url, body, false);

    return HttpService.parseResponse(response);
  }

  static Future<dynamic> resetForgottenPassword(
      String email, String code, String password) async {
    final url = '${EnvironmentConfiguration.BASE_API_URL}/pub/reset';
    final body = {'email': email, 'code': code, 'password': password};

    final response = await HttpService.post(url, body, false);

    return HttpService.parseResponse(response);
  }
}