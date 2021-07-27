import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_application_1/models/environment_configuration.dart';
import 'package:flutter_application_1/models/exceptions.dart';
import 'package:flutter_application_1/models/shared_preference_keys.dart';
import 'package:flutter_application_1/services/log_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Map<String, String> baseHeaders = {'Content-Type': 'application/json'};

class HttpService {
  static SharedPreferences _sharedPreferences;
  static final Uuid _uuid = Uuid();

  static String _url(String route) {
    return route.contains('://')
        ? route
        : '${EnvironmentConfiguration.BASE_API_URL}$route';
  }

  static Future<http.Response> delete(String route,
      [dynamic body, bool addAuthToken = true]) async {
    final url = _url(route);
    LogService.debug('DELETE $url');

    final headers = await _getHeaders(addAuthToken);
    final request = http.Request('DELETE', Uri.parse(url));
    request.headers.addAll(headers);

    if (body != null) {
      request.body = json.encode(body);
    }

    final response =
        await http.Client().send(request).then(http.Response.fromStream);

    LogService.debug('DELETE ${response.statusCode}');

    return response;
  }

  static Future<http.Response> get(String route,
      [bool addAuthToken = true]) async {
    final url = _url(route);
    LogService.debug('GET $url');

    final headers = await _getHeaders(addAuthToken);
    final response = await http.get(Uri.parse(url), headers: headers);

    LogService.debug('GET ${response.statusCode}');

    return response;
  }

  static Future<http.Response> infer(Uint8List data) async {
    final url = '$EnvironmentConfiguration.kInferHost$EnvironmentConfiguration.kInferPath';
    LogService.debug('POST $url');

    HttpClient ioClient = new HttpClient()
      ..badCertificateCallback = (_, __, ___) => true;
    http.Client client = IOClient(ioClient);

    final headers = await _getHeaders(false);
    final response = await client.post(
      Uri.parse(url),
      body: jsonEncode({
        'image': base64Encode(data),
        'name': '${_uuid.v4()}.jpg',
      }),
      headers: headers,
    );

    LogService.debug('POST ${response.statusCode}');
    return response;
  }

  static Future<http.Response> post(String route,
      [dynamic body, bool addAuthToken = true]) async {
    final url = _url(route);
    LogService.debug('POST $url');

    final headers = await _getHeaders(addAuthToken);
    final response =
        await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    LogService.debug('POST ${response.statusCode}');

    return response;
  }

  static Future<http.Response> put(String route,
      [dynamic body, bool addAuthToken = true]) async {
    final url = _url(route);
    LogService.debug('PUT $url');

    final headers = await _getHeaders(addAuthToken);
    print("body $body");
    final response =
        await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));

    LogService.debug('PUT ${response.body}');

    return response;
  }

  static Future<Map<String, String>> _getHeaders(bool addAuthToken) async {
    var headers = {...baseHeaders};

    if (addAuthToken) {
      if (_sharedPreferences == null) {
        _sharedPreferences = await SharedPreferences.getInstance();
      }

      final token = _sharedPreferences.getString(SharedPreferenceKeys.TOKEN);
     //LogService.debug("token $token");
      if (token?.isEmpty ?? true) {
        throw UnauthorizedException('Invalid token');
      }

      headers = {...headers, HttpHeaders.authorizationHeader: 'Bearer $token'};
    }
    // LogService.debug("headers $headers");

    return headers;
  }

  static dynamic parseResponse(http.Response response) {
    Map<String, dynamic> responseBody = {};

    try {
      responseBody = json.decode(response.body);
    } catch (ex) {
      LogService.error('HttpService parseResponse: $ex');
    }

    switch (response.statusCode) {
      case 200:
        return responseBody['result'];
      case 401:
        return Future.error(UnauthorizedException(responseBody['error']));
      case 404:
        return Future.error(NotFoundException(responseBody['error']));
      default:
        return Future.error(BadRequestException(
            responseBody['error'] ?? response.reasonPhrase));
    }
  }
}
