import 'package:flutter_application_1/models/environment_configuration.dart';
import 'package:flutter_application_1/models/news.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static Future<News> getNews() async {
    http.Response response = await http.get(
      Uri.parse(
        EnvironmentConfiguration.kNewsDomainAPIUrl 
        + EnvironmentConfiguration.kNewsSearchKey 
        + EnvironmentConfiguration.kNewsSearchAPIUrl 
        + EnvironmentConfiguration.kNewsAPIKey
      ),
    );

    if (response.statusCode == 200) {
      return newsFromJson(response.body);
    }
    return Future.error('error');
  }
}