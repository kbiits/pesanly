import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/components/divider_list_chat.dart';
import 'package:flutter_app/resources/components/item_list_chat.dart';
import 'package:flutter_app/resources/components/top_bar.dart';
import 'package:flutter_app/routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/controllers/contacts_controller.dart';

class ContactsPage extends NyStatefulWidget {
  final ContactsController controller = ContactsController();

  ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends NyState<ContactsPage> {
  final _searchController = TextEditingController();

  List<User> contacts = [];
  bool isApiLoading = true;

  @override
  init() async {
    User? user =
        await NyStorage.read(StorageKey.loggedInUser, model: new User());
    if (user == null) {
      routeTo(Routes.HOME);
      return;
    }

    Backpack.instance.set(StorageKey.loggedInUser, user.toJson());
    widget.controller.loadUser(user);
    List<User> users = await widget.controller.getAvailableContacts();

    setState(() {
      this.contacts = users;
      this.isApiLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildListContacts(List<User> users) {
    return users.map<Widget>((e) {
      return Container(
        child: Column(
          children: [
            ItemListChat(
              e,
            ),
            SizedBox(
              height: 25,
            ),
            DividerListChat(),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.context = context;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              TopBar(
                "Contacts",
                rightWidget: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    size: 28,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF152033),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: TextFormField(
                        controller: _searchController,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: const Color(0xFFADB5BD),
                            size: 24,
                          ),
                          border: InputBorder.none,
                          hintText: "search".tr(),
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: isApiLoading
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : contacts.length == 0
                              ? Container(
                                  child: Center(
                                    child: Text(
                                      "no_friends".tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    children: _buildListContacts(contacts),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
