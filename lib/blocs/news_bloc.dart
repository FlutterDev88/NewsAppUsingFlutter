import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/news.dart';
import 'package:flutter_application_1/services/news_service.dart';

class NewsBloc extends ChangeNotifier {

  News news;

  Future<News> loadingNewsData() async {
    news = await NewsService.getNews();

    if (news.data.length > 0) {
      notifyListeners();
      return news;
    }
    
    return Future.error('error');
  }
}