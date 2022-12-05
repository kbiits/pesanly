import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/config/button.dart';
import 'package:flutter_app/resources/themes/text_theme/default_text_theme.dart';
import 'package:flutter_app/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/controllers/register_phone_number_controller.dart';

class RegisterPhoneNumberPage extends NyStatefulWidget {
  final RegisterPhoneNumberController controller =
      RegisterPhoneNumberController();

  RegisterPhoneNumberPage({Key? key}) : super(key: key);

  @override
  _RegisterPhoneNumberPageState createState() =>
      _RegisterPhoneNumberPageState();
}

class _RegisterPhoneNumberPageState extends NyState<RegisterPhoneNumberPage> {
  TextEditingController _textFieldControllerPhoneNumber =
      TextEditingController();

  @override
  init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                this.pop();
              }),
        ),
        backgroundColor: ThemeColor.get(context).background,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "register_phone.enter_phone_num".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                "register_phone.confirm".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFF152033),
                              ),
                              height: 40,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      getImageAsset("indonesia.png"),
                                      scale: 0.8,
                                      alignment: Alignment.center,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "+62",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xFF152033),
                                ),
                                height: 40,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  controller: _textFieldControllerPhoneNumber,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        ThemeColor.get(context).primaryContent,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Phone Number",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: Container(
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
                        ),
                        child: Text(
                          "continue".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          handleForm();
                        },
                      ),
                    ),
                  ),
                  // child: ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleForm() {
    String phoneNumber = _textFieldControllerPhoneNumber.text;

    try {
      this.validator(
        rules: {
          "phone number": "min:10",
        },
        data: {
          "phone number": phoneNumber,
        },
        messages: {"phone number": "Oops|" + "phone_min_11".tr()},
        showAlert: true,
      );
    } catch (e) {
      return;
    }

    routeTo(Routes.REGISTER_DATA, data: phoneNumber);
  }
}
