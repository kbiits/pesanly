import 'package:flutter_app/config/size.dart';
import 'package:flutter_app/resources/pages/chat_page.dart';
import 'package:flutter_app/resources/pages/contacts_page.dart';
import 'package:flutter_app/resources/pages/onboarding_screen_page.dart';
import 'package:flutter_app/resources/pages/register_data_page.dart';
import 'package:flutter_app/resources/pages/register_phone_number_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| App Router
|
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "flutter pub run nylo_framework:main make:page my_page"
| Learn more https://nylo.dev/docs/3.x/router
|--------------------------------------------------------------------------
*/

class Routes {
  static final HOME = "/";
  static final REGISTER_PHONE_NUMBER = "/register-phone-number";
  static final REGISTER_DATA = "/register-data";
  static final CONTACTS_PAGES = "/contacts";
  static final CHAT_PAGES = "/chats";
}

appRouter() => nyRoutes((router) {
      router.route(Routes.HOME, (context) {
        ScreenSize().init(context);

        return OnboardingScreenPage();
      });

      router.route(Routes.REGISTER_PHONE_NUMBER, (context) {
        return RegisterPhoneNumberPage();
      });

      router.route(Routes.REGISTER_DATA, (context) {
        return RegisterDataPage();
      });

      router.route(Routes.CONTACTS_PAGES, (context) {
        return ContactsPage();
      });

      router.route(Routes.CHAT_PAGES, (context) {
        return ChatPage();
      });

      // Add your routes here

      // router.route("/new-page", (context) => NewPage(), transition: PageTransitionType.fade);
    });
