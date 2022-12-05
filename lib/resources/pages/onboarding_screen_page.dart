import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/config/button.dart';
import 'package:flutter_app/config/size.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/themes/text_theme/default_text_theme.dart';
import 'package:flutter_app/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/controllers/onboarding_screen_controller.dart';

class OnboardingScreenPage extends NyStatefulWidget {
  final OnboardingScreenController controller = OnboardingScreenController();

  OnboardingScreenPage({Key? key}) : super(key: key);

  @override
  _OnboardingScreenPageState createState() => _OnboardingScreenPageState();
}

class _OnboardingScreenPageState extends NyState<OnboardingScreenPage> {
  bool isAppLoading = true;

  @override
  init() async {
    await askContactsPermission();

    User? user =
        await NyStorage.read<User>(StorageKey.loggedInUser, model: new User());

    await Future.delayed(Duration(
      seconds: 1,
    ));

    if (user != null) {
      routeTo(Routes.CONTACTS_PAGES);
      return;
    }

    setState(() {
      this.isAppLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> askContactsPermission() async {
    var status = await Permission.contacts.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      status = await Permission.contacts.request();
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied) {
        SystemNavigator.pop(animated: true);
      }
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isAppLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                width: ScreenSize.screenWidth,
                height: ScreenSize.screenHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.asset(
                                  getImageAsset("onboarding-illustration.png")),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 70,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Text(
                                "onboarding_text".tr(),
                                textAlign: TextAlign.center,
                                style: defaultTextTheme.headline4!.copyWith(
                                  color: ThemeColor.get(context).primaryContent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  "onboarding_page.terms_policy".tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color:
                                        ThemeColor.get(context).primaryContent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              width: double.infinity,
                              height: CommonButtonProps.height,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          CommonButtonProps.roundedBorderRadius,
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((_) =>
                                          ThemeColor.get(context)
                                              .buttonBackground),
                                ),
                                onPressed: () {
                                  routeTo(Routes.REGISTER_PHONE_NUMBER);
                                },
                                child: Text(
                                  "onboarding_page.start_message".tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: ThemeColor.get(context)
                                        .buttonPrimaryContent,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
