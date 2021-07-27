import 'package:flutter/material.dart';

class CommonDialogs {
  static Future showInformationalDialog(
      BuildContext context, String title, String content) async {
    final textTheme = Theme.of(context).textTheme;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: textTheme.headline5),
          content: Text(content ?? '', style: textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  static Future showGenericErrorDialog(BuildContext context,
          {String content: 'Something went wrong!', String title: 'Oops!'}) =>
      showInformationalDialog(context, title, content);
}