import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String kThemeLocal = 'THEME_DATA';

// Spacing
const double kPadding = 5;
const double kSmallPadding = 10;
const double kMediumPadding = 20;
const double kLargePadding = 40;
const double kSpaceGap = 12.0;
const double kWidthRatio = 0.9;
const double kIconSize = 24;
double kCalculatedWidth(Size size) => size.width * kWidthRatio;
double kCalculatedMargin(Size size) => size.width * (1 - kWidthRatio) / 2;

// Colors
const Color kPrimaryColor = Colors.amber;
const Color kPrimaryTextColor = Colors.black;
const Color kSecondaryTextColor = Colors.white;
const Color kScaffoldBackgroundColor = Colors.white;
final Color kBorderColor = Colors.grey[350];
final Color kSubtextColor = Colors.grey[400];
final Color kColorBlack = Colors.black;
final Color kColorGrey = Colors.grey[100];
final Color kColorDarkGrey = Color(0xFF707070);
final Color kColorBlue = Color(0xFF5BA1D6);
final Color kColorDarkBlue = Color(0xFF5540FB);
final Color kColorOrange = Colors.orange;
final Color kColorRed = Color(0xFFED2683);
final Color kColorDarkRed = Color(0xffE74448);
final Color kColorGreen = Color(0xFFA0CD46);
final Color kColorLightGreen = Color(0xFF30E196);
final Color kColorYellow = Color(0xffFFC100);

// Text
final TextStyle kHeadline1TextStyle = GoogleFonts.notoSans(
    textStyle: TextStyle(
        fontSize: 30, fontWeight: FontWeight.bold, color: kPrimaryTextColor));
final TextStyle kHeadline2TextStyle = GoogleFonts.notoSans(
    textStyle: TextStyle(
        fontSize: 25, fontWeight: FontWeight.normal, color: kPrimaryTextColor));
final TextStyle kHeadline3TextStyle = GoogleFonts.notoSans(
    textStyle: TextStyle(
        fontSize: 19, fontWeight: FontWeight.normal, color: kPrimaryTextColor));
final TextStyle kBodyText1Style = GoogleFonts.notoSans(
    textStyle: TextStyle(fontSize: 16, color: kPrimaryTextColor));
final TextStyle kBodyText2Style = GoogleFonts.notoSans(
    textStyle: TextStyle(fontSize: 14, color: kPrimaryTextColor));
final TextStyle kSubtitle1Style = GoogleFonts.notoSans(
    textStyle: TextStyle(fontSize: 12, color: kSubtextColor));
final TextStyle kSubtitle2Style = GoogleFonts.notoSans(
    textStyle: TextStyle(fontSize: 12, color: kPrimaryTextColor));
final TextStyle kUnderlinetitleStyle = GoogleFonts.notoSans(
    textStyle: TextStyle(fontSize: 12, color: kSecondaryTextColor, decoration: TextDecoration.underline));

// Border
const double kBorderWidth = 1;
const double kThickBorderWidth = 3;
const BorderRadius kBorderRadius =
    BorderRadius.all(const Radius.circular(kSmallPadding));
const BorderRadius kFullBorderRadius =
    BorderRadius.all(const Radius.circular(100));
final BoxDecoration kTextFieldBoxDecoration = BoxDecoration(
    borderRadius: kBorderRadius,
    border: Border.all(color: kThemeData.dividerColor),
    color: Colors.white);
BoxDecoration kRoundedEdgesBoxDecoration(
        {Color backgroundColor,
        Color shadowColor,
        Color borderColor,
        double borderWidth = kThickBorderWidth,
        double radius = kSmallPadding,
        String image}) =>
    BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: shadowColor != null ? [kBoxShadow(shadowColor)] : null,
        color: backgroundColor ?? kScaffoldBackgroundColor,
        image: image != null
            ? DecorationImage(
                image: AssetImage(
                  image,
                ),
                fit: BoxFit.cover)
            : null);
final BoxDecoration kButtonBoxDecoration = BoxDecoration(
    borderRadius: kFullBorderRadius, border: Border.all(color: kPrimaryColor));
final BoxDecoration kBottomSheetBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: new BorderRadius.only(
    topLeft: const Radius.circular(25.0),
    topRight: const Radius.circular(25.0),
  ),
);
BoxShadow kBoxShadow(Color color) => BoxShadow(
      color: color,
      spreadRadius: 0,
      blurRadius: 5,
      offset: Offset(0, 2), // changes position of shadow
    );

final ThemeData kThemeData = ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kScaffoldBackgroundColor,
    dividerColor: kBorderColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(size: kIconSize),
    textTheme: TextTheme(
        headline1: kHeadline1TextStyle,
        headline2: kHeadline2TextStyle,
        headline3: kHeadline3TextStyle,
        bodyText1: kBodyText1Style,
        bodyText2: kBodyText2Style,
        subtitle1: kSubtitle1Style,
        subtitle2: kSubtitle2Style));

final ThemeData kThemeDataDark = ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: Colors.grey[900],
    dividerColor: kBorderColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(size: kIconSize),
    textTheme: TextTheme(
        headline1: kHeadline1TextStyle.copyWith(color: Colors.white),
        headline2: kHeadline2TextStyle.copyWith(color: Colors.white),
        headline3: kHeadline3TextStyle.copyWith(color: Colors.white),
        bodyText1: kBodyText1Style.copyWith(color: Colors.white),
        bodyText2: kBodyText2Style.copyWith(color: Colors.white),
        subtitle1: kSubtitle1Style.copyWith(color: Colors.white),
        subtitle2: kSubtitle2Style.copyWith(color: Colors.white)));