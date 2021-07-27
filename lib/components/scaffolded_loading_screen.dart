import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';

class ScaffoldedLoadingScreen extends StatelessWidget {
  final bool initial;

  ScaffoldedLoadingScreen({this.initial = false}) : super(key: Key('loading'));
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final margin = kCalculatedMargin(size);
    final width = kCalculatedWidth(size);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            CircularProgressIndicator(),
            if (initial) Container(height: kMediumPadding),
            if (initial)
              Container(
                margin: EdgeInsets.all(margin),
                child: Text(
                  'Loading! It may take a few minutes.',
                  style: theme.textTheme.headline3.copyWith(
                    color: kColorDarkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                width: width,
              ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}