import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/api_provider/api_constant.dart';
import 'package:thankxdriver/bloc/cms_bloc.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/LoginAndSignup/login_page.dart';
import 'package:thankxdriver/layout/MePage/ChangePassword/change_password.dart';
import 'package:thankxdriver/layout/MePage/Comman/comman_row_widget.dart';
import 'package:thankxdriver/layout/MePage/DepositAccount/DepositAccountPage.dart';
import 'package:thankxdriver/layout/MePage/Notification/push_notification_setting.dart';
import 'package:thankxdriver/layout/MePage/Review/review_page.dart';
import 'package:thankxdriver/layout/MePage/Wallet/wallet_page.dart';
import 'package:thankxdriver/layout/MePage/WebViewPage/web_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'ProfileDetail/profile_page.dart';
import 'TaxInformation/tax_information_page.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final CMSBLOC _bloc = CMSBLOC();
  StreamSubscription<BaseResponse> _logoutSubscription;
  StreamSubscription<CMSResponse> _cmsSubscription;

  final _ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () => this._callApiForCMSDetail());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ScaffoldKey,
      backgroundColor: AppColor.whiteColor,
      body: Container(
        child: Column(
          children: <Widget>[
            appBarContainer(),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(5)),
                    child: CommanRowWidget(
                      image: AppImage.profile,
                      lable: AppTranslations.globalTranslations.Profile,
                      onPress: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ProfilePage();
                        }));
                      },
                    ),
                  ),
                  CommanRowWidget(
                    image: AppImage.wallet,
                    lable: AppTranslations.globalTranslations.Wallet,
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return WalletPage();
                      }));
                    },
                  ),
                  CommanRowWidget(
                    image: AppImage.wallet,
                    lable: AppTranslations.globalTranslations.depositAccount,
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return DepositAccountPage();
                      }));
                    },
                  ),
                  CommanRowWidget(
                    image: AppImage.taxInformation,
                    lable: AppTranslations.globalTranslations.TaxInformation,
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return TaxInformationPage(
                          bloc: this._bloc,
                        );
                      }));
                    },
                  ),
                  CommanRowWidget(
                    image: AppImage.reviews,
                    lable: AppTranslations.globalTranslations.Reviews,
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ReviewPage();
                      }));
                    },
                  ),
                  CommanRowWidget(
                    image: AppImage.changePassword,
                    lable: AppTranslations.globalTranslations.ChangePassword,
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ChangePasswordPage();
                      }));
                    },
                  ),
                  SizedBox(
                    height: UIUtills().getProportionalHeight(52),
                  ),
                  CommanRowWidget(
                    image: AppImage.notifications,
                    lable: AppTranslations.globalTranslations.Notifications,
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return PushNotificaionSettingPage();
//                          NotificationSettings();
                      }));
                    },
                  ),
                  SizedBox(
                    height: UIUtills().getProportionalHeight(52),
                  ),
                  CommanRowWidget(
                    image: AppImage.aboutUs,
                    lable: AppTranslations.globalTranslations.AboutUs,
                    onPress: () {
                      NavigationService().push(
                        MaterialPageRoute(
                          builder: (_) => WebViewPage(
                            webViewType: WebViewType.aboutUs,
                          ),
                        ),
                      );
//                      this._callApiForCMSDetail(AppTranslations.globalTranslations.aboutUsTitle, this._bloc?.cmsModel?.aboutUs ?? "");

//                      MaterialPageRoute route = MaterialPageRoute(builder: (_)=>
//                          WebViewPage(titleText: AppTranslations.globalTranslations.aboutUsTitle,
//                              htmlText: this._bloc.cmsModel.aboutUs));
//                      Navigator.push(context,route);
                    },
                  ),
                  CommanRowWidget(
                    image: AppImage.privacyPolicy,
                    lable: AppTranslations.globalTranslations.PrivacyPolicy,
                    onPress: () {
                      NavigationService().push(
                        MaterialPageRoute(
                          builder: (_) => WebViewPage(
                            webViewType: WebViewType.privacyPolicy,
                          ),
                        ),
                      );
//                      this._callApiForCMSDetail(AppTranslations.globalTranslations.privacyAndpolicyTitle, this._bloc?.cmsModel?.privacyPolicyDriver ?? "");
//                      MaterialPageRoute route = MaterialPageRoute(builder: (_)=>
//                          WebViewPage(titleText: AppTranslations.globalTranslations.privacyAndpolicyTitle,
//                              htmlText: this._bloc.cmsModel.privacyPolicyDriver));
//                      Navigator.push(context,route);
                    },
                  ),
                  CommanRowWidget(
                    image: AppImage.termsofuse,
                    lable: AppTranslations.globalTranslations.TermsofUse,
                    onPress: () {
                      NavigationService().push(
                        MaterialPageRoute(
                          builder: (_) => WebViewPage(
                            webViewType: WebViewType.termsCondition,
                          ),
                        ),
                      );
//                        this._callApiForCMSDetail(AppTranslations.globalTranslations.termsTitle, this._bloc?.cmsModel?.termsConditionDriver ?? "");

//                        MaterialPageRoute route = MaterialPageRoute(builder: (_)=>
//                            WebViewPage(titleText: AppTranslations.globalTranslations.termsTitle,
//                                htmlText: this._bloc.cmsModel.termsConditionDriver));
//                        Navigator.push(context,route);
                    },
                  ),
                  SizedBox(
                    height: UIUtills().getProportionalHeight(52),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(50)),
                    child: CommanRowWidget(
                      image: AppImage.contactUs,
                      lable: AppTranslations.globalTranslations.ContactUs,
                      onPress: () {
                        _handleContactUsButtonEvent();
                      },
                    ),
                  ),
                  SizedBox(
                    height: UIUtills().getProportionalHeight(48),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(28), right: UIUtills().getProportionalWidth(28), bottom: UIUtills().getProportionalHeight(50)),
                    child: CommonButton(
                      height: UIUtills().getProportionalWidth(50),
                      width: double.infinity,
                      backgroundColor: AppColor.dialogDividerColor,
                      onPressed: () {
                        Utils.showAlert(context, message: "Are you sure you want to logout?", arrButton: ["Cancel", AppTranslations.globalTranslations.btnOK], callback: (int index) {
                          if (index == 1) {
                            logOutOperation();
                          }
                        });
                      },
                      textColor: AppColor.textColorLight,
                      fontName: AppFont.sfProTextMedium,
                      fontsize: 17,
                      characterSpacing: 0,
                      text: AppTranslations.globalTranslations.LogOut,
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future _handleContactUsButtonEvent() async {
    final bool mailEnable = await PlatformChannel().checkForMailSend();
    if (!mailEnable) {
      Utils.showAlert(context,
          title: AppTranslations.globalTranslations.appName, message: AppTranslations.globalTranslations.msgUnableToSendMail, arrButton: [AppTranslations.globalTranslations.buttonOk], callback: null);
      return;
    }

    final MailOptions mailOptions = MailOptions(
      body: 'Support Request',
      subject: 'Support Subject',
      recipients: [ApiConstant.thankxContactUs],
      isHTML: true,
      bccRecipients: [],
      ccRecipients: [],
      attachments: [],
    );

    await FlutterMailer.send(mailOptions);
  }

  Widget appBarContainer() {
    return Container(
      margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(70)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(17)),
            child: Text(
              AppTranslations.globalTranslations.meTitle,
              style: UIUtills().getTextStyle(fontName: AppFont.sfProTextBold, fontsize: 28, characterSpacing: 0.6, color: AppColor.textColor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(12)),
            height: 0.5,
            width: double.infinity,
            color: AppColor.textColorLight,
          ),
        ],
      ),
    );
  }

  //region LogOut Api call
  Future<void> logOutOperation() async {
    this._logoutSubscription = this._bloc.logOutStream.listen((BaseResponse response) {
      this._logoutSubscription.cancel();
      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);
        if (response.status) {
          User.currentUser.resetUserDetails();
          final MaterialPageRoute route = MaterialPageRoute(
            builder: (_) => LoginPage(),
          );
          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        } else {
          Utils.showSnakBarwithKey(_ScaffoldKey, response.message);
        }
      });
    });
    UIUtills().showProgressDialog(context);
    this._bloc.logOutUser();
  }

//endregion

  void _callApiForCMSDetail() {
    this._cmsSubscription = this._bloc.cmsResponseStream.listen(
      (CMSResponse response) {
        this._cmsSubscription.cancel();
        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            UIUtills().dismissProgressDialog(context);
            if (response.status) {
              setState(() {});
            } else {
              Utils.showSnakBarwithKey(_ScaffoldKey, response.message);
            }
          },
        );
      },
    );
    UIUtills().showProgressDialog(context);
    this._bloc.getCMSDetails();
  }
}
