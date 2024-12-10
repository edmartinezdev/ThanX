import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/bloc/cms_bloc.dart';
import 'package:thankxdriver/bloc/login_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/custom/tab_bar_screen.dart';
import 'package:thankxdriver/layout/IntroSlider/into_slider.dart';
import 'package:thankxdriver/layout/LoginAndSignup/signup_page.dart';
import 'package:thankxdriver/layout/MePage/WebViewPage/web_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import '../../api_provider/all_response.dart';
import 'forgot_password_page.dart';
import 'vehicle_page.dart';
import 'w9_form_page.dart';

class LoginPage extends StatefulWidget {
  final bool isInitailPage;
  LoginPage({this.isInitailPage = true,});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with AfterLayoutMixin{

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginBloc _bloc = LoginBloc();
  StreamSubscription<LoginResponse> subscription;

  final CMSBLOC _cmsbloc = CMSBLOC();
  StreamSubscription<CMSResponse> _cmsSubscription;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  double screenHeight = 0.0;
  EdgeInsets viewInsets = EdgeInsets.zero;



  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if(this.subscription !=null) this.subscription.cancel();
    if(this._cmsSubscription !=null) this._cmsSubscription.cancel();
    super.dispose();
  }

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
            key: _scaffoldKey,
            backgroundColor: AppColor.whiteColor,
            body: GestureDetector(
              onTap: () {
                print("Gesture called ");
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: stackView(),
              ),
            )));
  }

  Widget stackView() {
    return Stack(
      children: <Widget>[
        backgoundImageContainer(),
        Container(
          height: screenHeight,
          padding: EdgeInsets.only(top: (screenHeight * 0.43) - MediaQuery.of(context).padding.top),
          child: SafeArea(
            child: loginContainer(),
          ),
        )
      ],
    );
  }

  Widget backgoundImageContainer() {
    return Container(
      width: double.infinity,
      height: (screenHeight * 0.52),
      color: AppColor.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: UIUtills().getProportionalWidth(15),
                top: UIUtills().getProportionalWidth(55)),
            alignment: Alignment.centerLeft,
            height: UIUtills().getProportionalWidth(22.0),
            child: Visibility(
              visible: !this.widget.isInitailPage,
              child: GestureDetector(
                child: Image.asset(AppImage.backArrow),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Container(
            child: Image.asset(
              AppImage.logo,
              width: UIUtills().getProportionalWidth(128.0),
              height: UIUtills().getProportionalWidth(170.0),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: UIUtills().getProportionalHeight(55),
          ),
        ],
      ),
    );
  }

  Widget loginContainer() {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: AppColor.whiteColor,
              padding: EdgeInsets.only(
                left: UIUtills().getProportionalWidth(28),
                right: UIUtills().getProportionalWidth(28),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  textFieldContainer(),
                  Container(
                    height: screenHeight * 0.16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        loginButton(),
                        getStartText(),
                      ],),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget textFieldContainer() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(60),
          ),
          child: TextFieldWithLabel(
            onChanged: this._bloc.email,
//            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.emailAddress,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
            style: UIUtills().getTextStyleRegular(
              color: AppColor.textColor,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            textType: TextFieldType.email,
            action: TextInputAction.next,
            onEditCompletie: () {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            labelText: AppTranslations.globalTranslations.emailText,
            labelTextStyle: UIUtills().getTextStyleRegular(
              color: AppColor.textColorLight,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            focusNode: emailFocusNode,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(20),
          ),
          child: TextFieldWithLabel(
            onChanged: this._bloc.password,
            keyboardType: TextInputType.text,
            obscureText: true,
            action: TextInputAction.done,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            style: UIUtills().getTextStyleRegular(
              color: AppColor.textColor,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            textType: TextFieldType.none,

            onEditCompletie: () {
              FocusScope.of(context).unfocus();
            },
            labelText: AppTranslations.globalTranslations.password,
            labelTextStyle: UIUtills().getTextStyleRegular(
              color: AppColor.textColorLight,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            focusNode: passwordFocusNode,
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(23),
            bottom: UIUtills().getProportionalHeight(55),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return ForgotPasswordPage();
                  }));
            },
            child: Text(
              AppTranslations.globalTranslations.forgotPassword,
              style: UIUtills().getTextStyleRegular(
                  color: AppColor.textColor,
                  fontSize: 12,
                  characterSpacing: 0.0,
                  fontName: AppFont.sfProTextMedium),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginButton(){
    return Column(
      children: <Widget>[
        Container(
          child: CommonButton(
            height: UIUtills().getProportionalWidth(50),
            width: double.infinity,
            backgroundColor: AppColor.primaryColor,
            onPressed: () {
              _onClickLogin();
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) {
//                    return TabBarScreen();
//                  }));
            },
            textColor: AppColor.textColor,
            fontName: AppFont.sfProDisplayMedium,
            fontsize: 17,
            characterSpacing: 0.0,
            text: AppTranslations.globalTranslations.buttonLogin,
          ),
        ),
        InkWell(onTap: (){
          _callApiForCMSDetail();

        },child:Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(10),
          ),
          child: Text(
            AppTranslations.globalTranslations.termsAndConditionText,
            textAlign: TextAlign.center,
            style: UIUtills().getTextStyleRegular(
              color: AppColor.textColor,
              fontSize: 10,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
          ),
        ),)
      ],
    );
  }

  Widget getStartText() {
    return Container(
      margin: EdgeInsets.only(
        left: UIUtills().getProportionalWidth(36),
        right: UIUtills().getProportionalWidth(36),
        //bottom: UIUtills().getProportionalHeight(26),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return SignUpPage();
              }));
        },
        child: Text(
          AppTranslations.globalTranslations.getStartText,
          textAlign: TextAlign.center,
          style: UIUtills().getTextStyleRegular(
            color: AppColor.textColor,
            fontSize: 12,
            characterSpacing: 0.0,
            fontName: AppFont.sfProTextMedium,
          ),
        ),
      ),
    );
  }

  void _onClickLogin() {
    // Dismiss Keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    // Check valid form

    final validationResult = this._bloc.isValidForm();
    if (!validationResult.item1) {
      Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);

      return;
    }
    // Validate Form
    this.subscription = this._bloc.loginOptionStream.listen((LoginResponse response) {
      this.subscription.cancel();

      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);
        if (response.status) {
          if(response.data.vechicleInfoDone == false){
            var route = MaterialPageRoute(builder: (_) => VehiclePage());
            Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
            Utils.showSnakBarwithKey(_scaffoldKey, response.message);
          }
         else if(response.data.vechicleInfoDone == true && response.data.isw9FormDone == false){
            var route = MaterialPageRoute(builder: (_) => W9FormPage());
            Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
            Utils.showSnakBarwithKey(_scaffoldKey, response.message);
          }
         else if(response.data.vechicleInfoDone == true && response.data.isw9FormDone == true && response.data.isDriverActive == false){

           Utils.showAlert(context,title: "Awaiting Approval", message: "Your account is awaiting approval. You will be notified via email of your account status.", arrButton: [AppTranslations.globalTranslations.btnOK], callback: (_) => LoginPage() );

         }
          else if( response.data.vechicleInfoDone == true && response.data.isw9FormDone == true && response.data.isDriverActive == true  ){
            var route = MaterialPageRoute(builder: (_) => TabBarScreen());
            Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
            Utils.showSnakBarwithKey(_scaffoldKey, response.message);
          }
        } else {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        }
      });
    });
    // flutter defined function
    UIUtills().showProgressDialog(context);
    this._bloc.callLoginApi();
  }

  void _callApiForCMSDetail() {
    this._cmsSubscription = this._cmsbloc.cmsResponseStream.listen(
          (CMSResponse response) {
        this._cmsSubscription.cancel();

            UIUtills().dismissProgressDialog(context);
            if (response.status) {
              NavigationService().push(
                MaterialPageRoute(
                  builder: (_) => WebViewPage(
                    webViewType: WebViewType.termsCondition,
                  ),
                ),
              );

              setState(() {});
            } else {
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            }
//            Utils.showSnakBarwithKey(_scaffoldKey, response.message);

      },
    );

    UIUtills().showProgressDialog(context);
    this._cmsbloc.getCMSDetails();
  }

  @override
  void afterFirstLayout(BuildContext context) {
  }


}