import 'package:nylo_framework/nylo_framework.dart';

class User extends Storable {
  String name = "";
  String phone_number = "";
  String last_seen = "";

  User() {}

  User.fromJson(dynamic data) {
    name = data['name'];
    phone_number = data['phone_number'];
    last_seen = data['last_seen'] ?? "";
  }

  toJson() =>
      {"name": name, "phone_number": phone_number, "last_seen": last_seen};

  @override
  fromStorage(data) {
    this.name = data['name'];
    this.phone_number = data['phone_number'];
    this.last_seen = data['last_seen'] ?? "";
  }

  @override
  toStorage() => {
        "name": this.name,
        "phone_number": this.phone_number,
        "last_seen": this.last_seen,
      };
}
