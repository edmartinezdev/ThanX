import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/IntroSlider/intro_slider_comman_widget.dart';
import 'package:thankxdriver/layout/LoginAndSignup/login_page.dart';
import 'package:thankxdriver/layout/LoginAndSignup/signup_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  double screenHeight = 0.0;
  EdgeInsets viewInsets = EdgeInsets.zero;

  final controller = PageController(initialPage: 0);
  List<Widget> list = [
    IntroSliderWidgets(
      image: AppImage.walk_1,
      text1: AppTranslations.globalTranslations.page1Text1,
      text2: AppTranslations.globalTranslations.page1Text2,
      text3: AppTranslations.globalTranslations.page1Text3,
    ),
    IntroSliderWidgets(
      image: AppImage.walk_2,
      text1:AppTranslations.globalTranslations.page2Text1,
      text2:AppTranslations.globalTranslations.page2Text2,
      text3: AppTranslations.globalTranslations.page3Text3,
    ),
    IntroSliderWidgets(
      image: AppImage.walk_3,
      text1:AppTranslations.globalTranslations.page3Text1,
      text2: AppTranslations.globalTranslations.page3Text2,
      text3: AppTranslations.globalTranslations.page3Text3
    ),
    IntroSliderWidgets(
      image: AppImage.walk_4,
      text1: AppTranslations.globalTranslations.page4Text1,
      text2: AppTranslations.globalTranslations.page4Text2,
      text3: AppTranslations.globalTranslations.page4Text3,
    )
  ];

  var textStyle = UIUtills().getTextStyleRegular(
      fontName: AppFont.sfProDisplayLight,
      fontSize: 20,
      color: AppColor.introsliderText,
      characterSpacing: 0.1);

  var textStyle1 = UIUtills().getTextStyleRegular(
      fontName: AppFont.sfProDisplayBold,
      fontSize: 40,
      color: AppColor.introsliderText,
      characterSpacing: 0.2);

  var textStyle2 = UIUtills().getTextStyleRegular(
    fontName: AppFont.sfProTextLight,
    fontSize: 12,
    color: AppColor.textColor,
  );

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    UIUtills().updateScreenDimesion(height: deviceSize.height,width: deviceSize.width);

    screenHeight = MediaQuery.of(context).size.height;
    viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Stack(
              children: <Widget>[
                pageViewContainer(),
                Container(
                  height: screenHeight,
                  padding: EdgeInsets.only(top: screenHeight * 0.74),
                  child: commanContainer(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pageViewContainer() {
    return Container(
      height: (screenHeight * 0.80),
      padding: EdgeInsets.only(top: UIUtills().getProportionalHeight(20)),
      width: double.infinity,
      child: PageView(controller: controller, children: list),
    );
  }

  Widget commanContainer() {
    return Container(
        margin: EdgeInsets.only(
            left: UIUtills().getProportionalWidth(35),
            right: UIUtills().getProportionalWidth(35)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[dottedIndicator(), button(), loginText()],
        ));
  }

  Widget dottedIndicator() {
    return Container(
        margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(15)),
        child: SmoothPageIndicator(
          controller: controller,
          count: list.length,
          effect: ExpandingDotsEffect(
              spacing: UIUtills().getProportionalWidth(13),
              radius: 7.0,
              dotWidth: UIUtills().getProportionalWidth(7),
              dotHeight: UIUtills().getProportionalWidth(7),
              expansionFactor: 4,
              strokeWidth: 0.0,
              dotColor: Colors.black,
              activeDotColor: Colors.black),
        ));
  }

  Widget button() {
    return CommonButton(
      height: UIUtills().getProportionalWidth(50),
      width: double.infinity,
      backgroundColor: AppColor.primaryColor,
      onPressed: () {
        NavigationService().push(MaterialPageRoute(builder: (context) {return SignUpPage();},),);},
      textColor: Colors.black,
      characterSpacing: 0,
      fontName: AppFont.sfProDisplayMedium,
      fontsize: 17,
      text: AppTranslations.globalTranslations.buttonGetStarted,
    );
  }

  Widget loginText() {
    return GestureDetector(
      onTap: () {
        NavigationService().push(MaterialPageRoute(builder: (context) => LoginPage(isInitailPage: false,),),);},
      child: Container(
          margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(40)),
          child: Text(AppTranslations.globalTranslations.alreadyLoginText,
              style:  UIUtills().getTextStyleRegular(
                  color: AppColor.textColor,
                  fontSize: 12,
                  characterSpacing: 0.0,
                  fontName: AppFont.sfProTextMedium
              ))),
    );
  }
}
