import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/config/button.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/controllers/register_data_controller.dart';

class RegisterDataPage extends NyStatefulWidget {
  final RegisterDataController controller = RegisterDataController();

  RegisterDataPage({Key? key}) : super(key: key);

  @override
  _RegisterDataPageState createState() => _RegisterDataPageState();
}

class _RegisterDataPageState extends NyState<RegisterDataPage> {
  late String phoneNumber;

  TextEditingController _nameController = TextEditingController();

  bool isApiLoading = false;

  @override
  init() async {
    this.phoneNumber = widget.data();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "titles.register_data".tr(),
        ),
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
        child: !isApiLoading
            ? Container(
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
                              decoration: BoxDecoration(
                                color: Color(0xFF152033),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Image.asset(
                                getImageAsset("profile.png"),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    color: Color(0xFF152033),
                                    child: TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "fullname_required".tr(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
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
                                "save".tr(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () async {
                                int minDigit = 2;
                                String fullName = _nameController.text;
                                try {
                                  this.validator(rules: {
                                    "fullname": "min:${minDigit}",
                                  }, data: {
                                    "fullname": fullName,
                                  }, messages: {
                                    "fullname": "Oops|" +
                                        "fullname_min".tr(arguments: {
                                          "digit": (minDigit + 1).toString(),
                                        }),
                                  }, showAlert: true);
                                } catch (e) {
                                  return;
                                }
                                setState(() {
                                  this.isApiLoading = true;
                                });

                                phoneNumber = '0' + phoneNumber.replaceAll(r'^\+?(?:62)', '');

                                await widget.controller
                                    .tryRegister(phoneNumber, fullName);

                                setState(() {
                                  this.isApiLoading = false;
                                });
                              },
                            ),
                          ),
                        ),
                        // child: ,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
