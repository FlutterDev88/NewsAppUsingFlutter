class EnvironmentConfiguration {
  static const BASE_API_URL = String.fromEnvironment('BASE_API_URL',
      defaultValue: 'http://www.test.com:3000');
  static const IS_PRODUCTION =
      bool.fromEnvironment('dart.vm.product', defaultValue: false);
  static const String kInferHost = 'https://www.test.com';
  static const String kInferPath = '/image';

  static const String kNewsDomainAPIUrl = "https://newsapi.org/v2/everything?q=";
  static String kNewsSearchKey = "crypto";
  static const String kNewsSearchAPIUrl = "&from=2021-05-25&sortBy=publishedAt&apiKey=";
  static const String kNewsAPIKey = "828a6ecc708a4f969a8f60460c4a6e76";
}