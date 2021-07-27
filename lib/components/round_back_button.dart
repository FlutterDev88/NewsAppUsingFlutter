import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';

class RoundBackButton extends StatelessWidget {
  final Function callback;

  RoundBackButton({this.callback});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.headline2;

    return GestureDetector(
      onTap: callback != null ? callback : () => Navigator.of(context).pop(),
      child: Container(
          key: Key('scanpageBack'),
          padding: EdgeInsets.all(kSmallPadding / 2),
          decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back,
              size: textTheme.fontSize, color: textTheme.color)),
    );
  }
}