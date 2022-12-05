import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/chat_api_service.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'controller.dart';

class ChatItem {
  late String date;
  late bool fromMe;
  late String content;
  ChatItem(this.date, this.fromMe, this.content);

  ChatItem.fromJson(dynamic data, String currentPhone) {
    this.fromMe = data['from'] == currentPhone;
    this.content = data['content'];
    this.date = data['created_at'];
  }
}

class ChatController extends Controller {
  late ChatApiService _service;
  late User user;

  construct(BuildContext context) {
    _service = ChatApiService(buildContext: context);
    user = User.fromJson(Backpack.instance.read(StorageKey.loggedInUser));
    super.construct(context);
  }

  Future<List<ChatItem>> getChats(DateTime time, User toUser) async {
    dynamic result = await _service.getChats(this.user, toUser);
    return result['chats'] ?? [];
  }

  Future<ChatItem?> sendMessage(String message, User toUser) async {
    return await _service.sendMessage(message, this.user, toUser);
  }

  Future<dynamic> pollNewChats(String lastDate, User toUser) async {
    return await _service.getChats(this.user, toUser, date: lastDate);
  }
}
