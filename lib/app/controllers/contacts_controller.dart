import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/contact_api_service.dart';

import 'controller.dart';

class _ContactHelper {
  late String nameFromDevice;
  Map<String, bool> phones = new Map();
}

class ContactsController extends Controller {
  late ContactApiService _service;
  User currentLoggedInUser = User();

  List<User> availableContacts = [];

  construct(BuildContext context) {
    _service = ContactApiService(buildContext: context);
    super.construct(context);
  }

  void loadUser(User user) {
    currentLoggedInUser = user;
  }

  Future<List<User>> getAvailableContacts() async {
    if (currentLoggedInUser.name == "") {
      return [];
    }

    List<String> _phones = [];
    var _users = await readDeviceContacts();
    _users.forEach((element) {
      _phones.addAll(element.phones.keys.toList());
    });

    var result = await _service.getAvailableContacts(
        _phones, currentLoggedInUser.phone_number);
    return result;
  }

  Future<List<_ContactHelper>> readDeviceContacts() async {
    List<Contact> contacts = await ContactsService.getContacts();
    List<_ContactHelper> users = contacts.map<_ContactHelper>((c) {
      _ContactHelper contact = new _ContactHelper();
      contact.nameFromDevice = c.displayName ?? "";
      c.phones?.forEach((e) {
        if (e.value != null) {
          contact.phones[e.value!] = true;
        }
      });

      return contact;
    }).where((element) {
      return !(element.phones[currentLoggedInUser.phone_number] ?? false);
    }).toList();

    return users;
  }
}
