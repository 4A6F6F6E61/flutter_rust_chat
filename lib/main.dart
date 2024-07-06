import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/global.dart';
import 'package:flutter_rust/pages/home/tabs/fibonacci/fibonacci_tab.dart';
import 'package:flutter_rust/pages/home/tabs/home/home_binding.dart';
import 'package:flutter_rust/pages/home/tabs/home/home_page.dart';
import 'package:flutter_rust/pages/home/tabs/chats/chats_tab.dart';
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
  log("RustLib initialized", name: "INFO");

  await dotenv.load();
  log("Dotenv loaded", name: "INFO");

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );
  log("Supabase initialized", name: "INFO");

  checkIfUserExists();

  log("Starting app...", name: "INFO");
  runApp(const Splash());
}

void checkIfUserExists() {
  // Ignore if the user is not logged in
  if (Supabase.instance.client.auth.currentUser == null) {
    return;
  }

  // Check if the user exists in the database
  final user = Supabase.instance.client.auth.currentUser;

  DB.users.select().eq('id', user!.id).then((response) {
    if (response.isNotEmpty) {
      log("User already exists, all good!", name: "checkIfUserExists");
      return;
    }

    log("User does not exist in the database, creating...", name: "INFO");

    try {
      DB.users.insert(
        {'id': user.id, 'name': user.email?.split("@").first, 'email': user.email},
      ).then((response) {
        log("User created successfully", name: "INFO");
      });
    } catch (e) {
      log("Error creating user: $e", name: "ERROR");
    }
  });
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final subscription = Supabase.instance.client.auth.onAuthStateChange.listen((AuthState state) {
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
    return GetMaterialApp(
      initialRoute: Supabase.instance.client.auth.currentUser == null ? '/login' : '/',
      onDispose: () {
        subscription.cancel();
      },
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
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
          binding: HomeBinding(),
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
