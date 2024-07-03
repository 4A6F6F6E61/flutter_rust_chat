import 'package:flutter/cupertino.dart';
import 'package:flutter_rust/pages/home/tabs/chats_tab.dart';
import 'package:flutter_rust/pages/home/tabs/settings/settings_tab.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_fill),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_alt_fill),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return const ChatsTab();
          case 1:
            return const SettingsTab();
          default:
            return const ChatsTab();
        }
      },
    );
  }
}
