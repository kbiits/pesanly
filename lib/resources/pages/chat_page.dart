import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/resources/components/top_bar.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/controllers/chat_controller.dart';
import 'dart:math' as math;

class ChatPage extends NyStatefulWidget {
  final ChatController controller = ChatController();

  ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends NyState<ChatPage> {
  late final User user;
  TextEditingController _messageController = TextEditingController();

  final int thresholdFailedPoll = 2;

  bool isApiLoading = true;
  List<ChatItem> chats = [];
  String lastDate = "";
  late Timer timer;
  int failedCount = 0;

  @override
  init() async {
    this.user = widget.data();
    this.chats = await widget.controller.getChats(DateTime.now(), this.user);
    setState(() {
      this.isApiLoading = false;
      if (chats.length > 0) {
        this.lastDate = chats.first.date;
      }
    });
    timer = Timer.periodic(Duration(seconds: 2), pollNewChats);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TopBar(
                user.name.capitalize(),
                alignment: MainAxisAlignment.start,
                leftWidget: IconButton(
                  onPressed: () {
                    this.pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: const Color(0xFF152033),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: this.isApiLoading
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      controller: ScrollController(),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        var data = chats[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: data.fromMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: data.fromMe
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        )
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                  color: data.fromMe
                                      ? ThemeColor.get(context).buttonBackground
                                      : ThemeColor.get(context).background,
                                ),
                                child: Text(
                                  data.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      // height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF152033),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "input_message".tr(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Transform.rotate(
                      angle: -45 * math.pi / 180,
                      child: IconButton(
                        onPressed: () {
                          String message = _messageController.text;
                          sendMessage(message);
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: const Color(0xFF375FFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void sendMessage(String message) async {
    var result = await widget.controller.sendMessage(message, this.user);
    if (result != null) {
      setState(() {
        _messageController.text = "";
        this.chats.insert(0, result);
        this.lastDate = result.date;
      });
    }
  }

  void pollNewChats(Timer t) async {
    if (failedCount > thresholdFailedPoll) {
      t.cancel();
      return;
    }
    DateTime? newDateTime = DateTime.tryParse(lastDate);
    if (newDateTime == null) {
      showToastNotification(
        context,
        style: ToastNotificationStyleType.DANGER,
        title: "Oops",
        description: "Failed parse date ${lastDate}",
        icon: Icons.error,
      );
      return;
    }

    String newDate = newDateTime.toUtc().toIso8601String();
    newDate = newDate.substring(0, newDate.length - 1) + "%2B00:00";
    print("new date ${newDate}");

    dynamic results = await widget.controller.pollNewChats(newDate, this.user);
    if (!results['success']) {
      this.failedCount++;
    }
    List<ChatItem> newChats = results['chats'] ?? [];
    if (newChats.length > 0) {
      setState(() {
        this.lastDate = newChats.first.date;
        this.chats.insertAll(0, newChats);
      });
    }
  }
}
