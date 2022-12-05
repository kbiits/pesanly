import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/mixin_show_error_api_service.dart';
import '../../app/networking/dio/base_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ContactApiService extends BaseApiService with ApiServiceShowError {
  ContactApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  /// Example API Request
  Future<List<User>> getAvailableContacts(List<String> phones, String myphone) async {
    return await network<dynamic>(
      request: (request) => request.post("/friends?myphone=${myphone}", data: {
        "phones": phones,
      }),
      handleSuccess: (response) {
        List<dynamic> data = response.data?['data'] ?? [];
        List<User> _users = [];
        data.forEach((element) {
          User _user = User.fromJson(element);
          _users.add(_user);
        });

        return _users;
      },
      handleFailure: (e) {
        return [];
      },
    );
  }
}
