import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/asset_image_paths.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;
  final List<Widget> children;
  final String backgroundUrl;

  const LoginBackground(
      {Key key,
      this.child,
      this.children,
      this.backgroundUrl = AssetImagePaths.backgroundDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(backgroundUrl), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: child != null ? [child] : children,
                  )),
            )));
  }
}