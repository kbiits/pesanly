import 'package:flutter/cupertino.dart';

class TopBar extends StatelessWidget {
  final String title;
  final Widget? rightWidget;
  final Widget? leftWidget;
  final MainAxisAlignment alignment;

  TopBar(this.title, {super.key, this.rightWidget, this.leftWidget, this.alignment = MainAxisAlignment.spaceBetween});

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChild = [];
    if (leftWidget != null) {
      columnChild.add(leftWidget!);
    }
    columnChild.add(
      Text(
        this.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
    );
    if (rightWidget != null) {
      columnChild.add(rightWidget!);
    }
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
      ),
      child: Row(
        mainAxisAlignment: this.alignment,
        children: columnChild,
      ),
    );
  }
}
