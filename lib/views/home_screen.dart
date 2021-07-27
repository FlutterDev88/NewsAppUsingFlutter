import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/news_bloc.dart';
import 'package:flutter_application_1/models/environment_configuration.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/asset_image_paths.dart';
import 'package:flutter_application_1/models/news.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/views/news_detail_screen.dart';
import 'package:flutter_application_1/views/settings_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final key = new GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('News'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: (){
              SettingsDrawer.openDrawer(context);
            }
          )
        ],
      ),
      body: _newsWidget(),
    );
  }

  Widget _newsWidget() {
    return Consumer<NewsBloc>(builder: (context, newsProvider, child) {
      return FutureBuilder<News>(
        future: newsProvider.loadingNewsData(),
        builder: (context, AsyncSnapshot<News> snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          else {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: snapshot.data.data.length == 0
                ? Center(
                  child: Text(
                    'There is no news',
                    style: kHeadline2TextStyle,
                  ),
                )
                : SingleChildScrollView(
                child: new Column(
                  children: List.generate(
                    snapshot.data.data.length,
                    (index) {
                      final Article article = snapshot.data.data[index];
                      return Container(
                        margin: EdgeInsets.all(kMediumPadding/4),
                        padding: EdgeInsets.all(kSmallPadding/2),
                        decoration: kRoundedEdgesBoxDecoration(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          shadowColor: kBorderColor,
                          borderColor: kBorderColor,
                          borderWidth: 1.0,
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailPage(article: article),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: article.urlToImage == null
                            ? AssetImage(AssetImagePaths.news)
                            : NetworkImage(article.urlToImage),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(article.title, maxLines: 2),
                        ),
                      );
                    }
                  ),
                ),
              ),
            );
          }
        }
      );
    });
  }
}