import 'package:flutter/cupertino.dart';
import 'package:flutter_rust/pages/home/home_page.dart';
import 'package:flutter_rust/pages/home/tabs/chats_tab.dart';
import 'package:flutter_rust/pages/home/tabs/settings/settings_tab.dart';
import 'package:flutter_rust/pages/login/login_binding.dart';
import 'package:flutter_rust/pages/login/login_page.dart';
import 'package:flutter_rust/pages/welcome_page.dart';
import 'package:flutter_rust/src/rust/api/simple.dart';
import 'package:flutter_rust/src/rust/frb_generated.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';

Future<void> main() async {
  await RustLib.init();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  runApp(const Splash());
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Supabase.instance.client.auth.onAuthStateChange.listen((AuthState state) {
      switch (state.event) {
        case AuthChangeEvent.signedIn:
          Get.offAllNamed('/');
          break;
        case AuthChangeEvent.signedOut:
        case AuthChangeEvent.userDeleted:
          Get.offAllNamed('/login');
          break;
        default:
          log("Unhandled AuthChangeEvent: ${state.event}");
          break;
      }
    });
    return GetCupertinoApp(
      initialRoute: Supabase.instance.client.auth.currentUser == null ? '/login' : '/',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/welcome',
          page: () => const WelcomePage(),
        ),
        GetPage(
          name: '/',
          page: () => const HomePage(),
          children: [
            GetPage(
              name: '/chats',
              page: () => const ChatsTab(),
            ),
            GetPage(
              name: '/settings',
              page: () => const SettingsTab(),
            ),
          ],
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('flutter_rust_bridge quickstart'),
        ),
        child: Center(
          child: Text('Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
        ),
      ),
    );
  }
}
