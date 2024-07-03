import 'package:flutter/cupertino.dart';
import 'package:flutter_rust/pages/home/tabs/settings/settings_main.dart';
import 'package:get/get.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool b) async {
        Get.back(id: 1);
      },
      child: Navigator(
        key: Get.nestedKey(1),
        onGenerateRoute: (RouteSettings settings) {
          return GetPageRoute<void>(
            settings: settings,
            page: () => const SettingsMain(),
          );
        },
      ),
    );
  }
}
