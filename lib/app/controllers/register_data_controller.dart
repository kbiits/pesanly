import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/user_api_service.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'controller.dart';
import 'package:flutter/widgets.dart';

class RegisterDataController extends Controller {
  late UserApiService _service;
  construct(BuildContext context) {
    _service = UserApiService(buildContext: context);
    super.construct(context);
  }

  Future<bool> tryRegister(String phoneNum, String fullname) async {
    User user = User.fromJson({
      "name": fullname,
      "phone_number": phoneNum,
    });

    try {
      await _service.register(user: user);
      await user.save(StorageKey.loggedInUser);
      routeTo(Routes.CONTACTS_PAGES);

      return true;
    } catch (e) {}

    return false;
  }
}
