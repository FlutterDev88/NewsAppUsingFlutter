import 'dart:convert';

import 'article.dart';

class News {
  String status;
  List<Article> data;

  News({this.status, this.data});

  factory News.fromJson(Map<String, dynamic> json) => News(
    status: json['status'],
    data: List<Article>.from(json['articles'].map((x) => Article.fromJson(x)))
  );
}

News newsFromJson(String str) => News.fromJson(json.decode(str));