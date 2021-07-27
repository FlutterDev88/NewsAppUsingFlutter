import 'dart:convert';

import 'package:flutter_application_1/models/environment_configuration.dart';
import 'package:flutter_application_1/models/exceptions.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/http_service.dart';
import 'package:flutter_application_1/services/log_service.dart';
import 'package:http/http.dart';


class UserService {
  Future<UserModel> getUser() async {
    final url = '${EnvironmentConfiguration.BASE_API_URL}/builder';

    final response = await HttpService.get(url);
    final responseBody = _parseResponse(response);
    print("responseBody $responseBody");
    switch (response.statusCode) {
      case 200:
        return UserModel.fromJsonResponse(response.body);
      case 401:
      default:
        return responseBody;
    }
  }

  static dynamic _parseResponse(Response response) {
    Map<String, dynamic> responseBody = {};

    try {
      responseBody = json.decode(response.body);
    } catch (ex) {
      LogService.error('AuthService: $ex');
    }

    switch (response.statusCode) {
      case 200:
        return responseBody['result'];
      case 401:
        return Future.error(UnauthorizedException(responseBody['error']));
      default:
        return Future.error(BadRequestException(responseBody['error']));
    }
  }
}
