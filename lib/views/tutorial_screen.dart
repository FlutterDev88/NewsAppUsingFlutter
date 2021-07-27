import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/user_bloc.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/components/round_back_button.dart';
import 'package:flutter_application_1/components/rounded_button.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/asset_image_paths.dart';

class TutorialScreen extends StatefulWidget {
  final bool shouldPopOnExit;

  TutorialScreen({this.shouldPopOnExit = true});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final _carouselController = CarouselController();
  int _currentIndex = 0;
  bool _imagesCached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_imagesCached) {
      _precacheImage(AssetImagePaths.largeFallingPieces);
      _precacheImage(AssetImagePaths.redPiece);
      _precacheImage(AssetImagePaths.coins);
      _precacheImage(AssetImagePaths.coinVault);

      _imagesCached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final margin = EdgeInsets.all(kCalculatedMargin(size) * 1.5);

    final tutorialItems = [
      _buildTutorialItem(margin, 'WELCOME', AssetImagePaths.largeFallingPieces,
          '\r\nThanks for downloading the app.\r\n\r\nGet ready to start your LEGO® adventure!'),
      _buildTutorialItem(margin, 'SNAPSHOT', AssetImagePaths.redPiece,
          'Gather all your LEGO® pieces! When scanning, use a white background, have good lighting (not in the dark), and hold the camera steady. Then select the correct piece.'),
      _buildTutorialItem(margin, 'VAULT', AssetImagePaths.coinVault,
          'Track all your LEGO® pieces that you\'ve scanned and see how much they are worth. This is just like a real BANK account, except instead of money, its LEGO® pieces!'),
      _buildTutorialItem(margin, 'COINS', AssetImagePaths.coins,
          'Hey look, you earn a coin when you scan a piece or complete challenges within BrickBanker!\r\n\r\nCoins can be used to earn more rewards.')
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImagePaths.backgroundLight),
            fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: margin.copyWith(bottom: 0),
                child: RoundBackButton(callback: _onExit)),
              Container(
                child: Center(
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    items: [
                      ...tutorialItems,
                      Container(
                        margin: margin.copyWith(top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Ready to get started?',
                                  style: textTheme.headline1
                                      .copyWith(color: Colors.black))),
                            SizedBox(height: kMediumPadding),
                            RoundedButton(
                              label: 'Get Building!', onPressed: _onExit),
                            SizedBox(height: kSmallPadding),
                            RoundedButton(
                              label: 'Show Me Again!',
                              // isPrimary: false,
                              onPressed: () {
                                _carouselController.jumpToPage(0);
                              })
                          ]
                        ),
                      )
                    ],
                    options: CarouselOptions(
                      initialPage: _currentIndex,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      height: size.height * 0.75,
                      viewportFraction: 0.9,
                      onPageChanged: (index, reason) {
                        setState(() => _currentIndex = index);
                      })),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                  List<Widget>.generate(tutorialItems.length + 1, (index) {
                    const dimensions = kMediumPadding * 0.6;
                    const indicatorMargin = EdgeInsets.symmetric(
                      vertical: kSmallPadding, horizontal: kSmallPadding / 2);

                    return Container(
                      width: dimensions,
                      height: dimensions,
                      margin: indicatorMargin.copyWith(bottom: kMediumPadding),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withAlpha(100)),
                      ),
                      child: _currentIndex == index
                        ? Image.asset(AssetImagePaths.coin)
                        : null);
                  }
                )
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _buildTutorialItem(EdgeInsetsGeometry margin, String title,
      String imagePath, String description) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: margin,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.center, children: [
              Image.asset(imagePath, height: size.width * 0.5),
              Image.asset(AssetImagePaths.darkGrid, height: size.width * 0.6)
            ]),
            Container(
                padding: EdgeInsets.all(kCalculatedMargin(size) / 4),
                decoration: kRoundedEdgesBoxDecoration(
                    borderColor: Colors.black,
                    borderWidth: kThickBorderWidth * 2),
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: textTheme.headline1.copyWith(color: Colors.black))),
            Text(description,
                textAlign: TextAlign.center,
                style: textTheme.bodyText1.copyWith(color: Colors.black))
          ]),
    );
  }

  void _onExit() {
    if (widget.shouldPopOnExit) {
      Navigator.of(context).pop();
    } else {
      final userProvider = Provider.of<UserBloc>(context, listen: false);
      userProvider.setFirstTimeLogin(false);
    }
  }

  void _precacheImage(String imageUrl) {
    precacheImage(Image.asset(imageUrl).image, context);
  }
}