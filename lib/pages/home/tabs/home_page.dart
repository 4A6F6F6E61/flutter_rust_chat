import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rust/pages/home/tabs/chats/chats_tab.dart';
import 'package:flutter_rust/pages/home/tabs/fibonacci/fibonacci_tab.dart';
import 'package:flutter_rust/pages/home/tabs/settings/settings_tab.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.red,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.chat_bubble_outline_sharp),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.fiber_manual_record_sharp)),
            label: 'Fibonacci',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.settings),
            ),
            label: 'Settings',
          ),
        ],
      ),
      body: [
        ChatsTab(),
        FibonacciTab(),
        SettingsTab(),
      ][currentPageIndex],
    );
  }
}
