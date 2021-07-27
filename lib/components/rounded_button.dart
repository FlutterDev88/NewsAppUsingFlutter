import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final bool isPrimary;
  final bool padding;
  final double widthRatio;
  final Color color;
  final Key key;

  RoundedButton({
    this.label,
    this.onPressed,
    this.isPrimary = true,
    this.padding = true,
    this.widthRatio = 1,
    this.color,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final determinedColor = color != null ? color : kPrimaryColor;

    return Container(
      width: widthRatio != null ? kCalculatedWidth(size) * widthRatio : null,
      child: FlatButton(
          padding: padding
              ? EdgeInsets.symmetric(
                  horizontal: kMediumPadding, vertical: kSmallPadding)
              : EdgeInsets.all(0),
          child: Text(label,
              style: theme.textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPrimary
                      ? theme.scaffoldBackgroundColor
                      : determinedColor)),
          shape: RoundedRectangleBorder(
              borderRadius: kBorderRadius,
              side: BorderSide(
                  color: determinedColor,
                  width: kThickBorderWidth,
                  style: BorderStyle.solid)),
          onPressed: onPressed,
          color: isPrimary ? determinedColor : Colors.transparent),
    );
  }
}