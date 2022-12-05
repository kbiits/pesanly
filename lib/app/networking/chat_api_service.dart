import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/chat_controller.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/mixin_show_error_api_service.dart';
import '../../app/networking/dio/base_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ChatApiService extends BaseApiService with ApiServiceShowError {
  ChatApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<dynamic> getChats(User currentUser, User toUser,
      {String date = ""}) async {
    var dataOuter = {};
    List<ChatItem>? result = await network<List<ChatItem>>(
      request: (api) => api.get(
          "/get-chats?for_user=${currentUser.phone_number}&to_user=${toUser.phone_number}&after=${date}"),
      handleFailure: (error) {
        dataOuter['success'] = false;
        List<ChatItem> result = [];
        return result;
      },
      handleSuccess: (response) {
        dataOuter['success'] = true;
        List<dynamic> data = response.data['data'] ?? [];
        return data.map<ChatItem>((element) {
          var chatItem = ChatItem.fromJson(element, currentUser.phone_number);
          return chatItem;
        }).toList();
      },
    );

    dataOuter['chats'] = result;

    return dataOuter;
  }

  Future<ChatItem?> sendMessage(
      String message, User currentUser, User toUser) async {
    ChatItem? result = await network<ChatItem>(
      request: (api) => api.post("/post-chats", data: {
        "from": currentUser.phone_number,
        "to": toUser.phone_number,
        "content": message,
      }),
      handleFailure: (_) {
        return null;
      },
      handleSuccess: (response) {
        var data = response.data['data'];
        return new ChatItem(data['created_at'], true, data['content']);
      },
    );

    return result;
  }
}
