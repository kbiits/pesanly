import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/mixin_show_error_api_service.dart';
import '../../app/networking/dio/base_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/models/user.dart';

class UserApiService extends BaseApiService with ApiServiceShowError {
  UserApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  /// Return a list of users
  Future<List<User>?> fetchAll({dynamic query}) async {
    return await network<List<User>>(
      request: (request) =>
          request.get("/endpoint-path", queryParameters: query),
    );
  }

  /// Find a User
  Future<User?> find({required int id}) async {
    return await network<User>(
      request: (request) => request.get("/endpoint-path/$id"),
    );
  }

  /// Create a User
  Future<User?> create({required dynamic data}) async {
    return await network<User>(
      request: (request) => request.post("/endpoint-path", data: data),
    );
  }

  /// Update a User
  Future<User?> update({dynamic query}) async {
    return await network<User>(
      request: (request) =>
          request.put("/endpoint-path", queryParameters: query),
    );
  }

  /// Delete a User
  Future<bool?> delete({required int id}) async {
    return await network<bool>(
      request: (request) => request.delete("/endpoint-path/$id"),
    );
  }

  Future<void> register({required User user}) async {
    await network<dynamic>(
      request: (req) => req.post("/register", data: user.toJson()),
      handleSuccess: (res) => true,
      handleFailure: (res) {
        var errMessage = res.response?.data?['error'] ?? 'Unknown error';
        throw new Exception(errMessage);
      },
    );
  }
}
