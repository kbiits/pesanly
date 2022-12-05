import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ItemListChat extends StatelessWidget {
  final User user;
  late final bool isOnline;

  ItemListChat(this.user, {super.key}) {
    this.isOnline = this.user.last_seen.toLowerCase() == "online";
  }

  String getNameConcise() {
    var d = this.user.name.split(" ");
    if (d.length == 0) {
      return "N/A";
    }

    return d[0][0] + (d.length >= 2 ? d[1][0] : "");
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      child: InkWell(
        onTap: () {
          routeTo(Routes.CHAT_PAGES, data: user);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green.shade500,
                  width: 1,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: ThemeColor.get(context).buttonBackground,
                ),
                child: Text(
                  getNameConcise(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 24,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      this.user.name,
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 23,
                  child: Container(
                    child: Text(
                      this.user.last_seen,
                      style: TextStyle(
                        color: const Color(0xFFADB5BD),
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
