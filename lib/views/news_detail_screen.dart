import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/asset_image_paths.dart';

class NewsDetailPage extends StatefulWidget {
  final Article article;

  NewsDetailPage({this.article});
  
  @override
  State<StatefulWidget> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(widget.article.title == null
          ? '' 
          : widget.article.title
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.1, 
          horizontal: size.width * 0.05
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: size.width * 0.25,
              backgroundImage: widget.article.urlToImage == null 
                ? AssetImage(AssetImagePaths.news) 
                : NetworkImage(widget.article.urlToImage
              ),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              child: Text(widget.article.publishedAt == null
                ? '' 
                : widget.article.publishedAt,
              ),
            ),
            Container(
              child: Text(widget.article.author == null 
                ? '' 
                : widget.article.author,
                maxLines: 2,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              widget.article.content == null 
                ? '' 
                : widget.article.content, 
              maxLines: 5,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: size.height * 0.05),
            GestureDetector(
              onTap: () => _openURL(widget.article.url),
              child: Text(
                widget.article.url,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.blue[300]
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}