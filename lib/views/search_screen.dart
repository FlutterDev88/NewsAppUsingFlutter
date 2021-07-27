import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/news_bloc.dart';
import 'package:flutter_application_1/components/dialog.dart';
import 'package:flutter_application_1/models/environment_configuration.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/asset_image_paths.dart';
import 'package:flutter_application_1/models/news.dart';
import 'package:flutter_application_1/views/news_detail_screen.dart';
import 'package:flutter_application_1/views/settings_drawer.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({ Key key }) : super(key: key);
  @override
  _SearchScreenState createState() => new _SearchScreenState();

}

class _SearchScreenState extends State<SearchScreen>
{
  final key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsBloc>(context, listen: false);
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: _newsWidget(newsProvider),
    );
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: TextField(
        onSubmitted: (value) {
          if (value.isEmpty) {
            CommonDialogs.showInformationalDialog(context, 'Alert', 'Please input search key');
            return;
          }
          if (EnvironmentConfiguration.kNewsSearchKey == value) {
            return;
          }

          EnvironmentConfiguration.kNewsSearchKey = value;
          Provider.of<NewsBloc>(context, listen: false).loadingNewsData();
          setState(() {});
        },
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          // hintText: kNewsSearchKey,
          hintStyle: TextStyle(color: Colors.white)
        ),
      ),
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
    );
  }

  Widget _newsWidget(NewsBloc newsProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: newsProvider.news == null || newsProvider.news.data.length == 0
        ? Center(
          child: Text(
            'There is no news',
            style: kHeadline2TextStyle,
          ),
        )
        : SingleChildScrollView(
        child: new Column(
          children: List.generate(
            newsProvider.news.data.length,
            (index) {
              final Article article = newsProvider.news.data[index];
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