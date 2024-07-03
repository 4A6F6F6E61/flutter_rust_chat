import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // controller: _scrollController,

        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Settings'),
            // backgroundColor: CupertinoColors.black,
          ),
          SliverList.list(
            children: [
              CupertinoListSection.insetGrouped(
                header: const Text('Account'),
                children: const [
                  CupertinoListTile(
                    title: Text('Account'),
                    subtitle: Text('Manage your account'),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                  CupertinoListTile(
                    title: Text('Notifications'),
                    subtitle: Text('Manage your notifications'),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                  CupertinoListTile(
                    title: Text('Privacy'),
                    subtitle: Text('Manage your privacy settings'),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                  CupertinoListTile(
                    title: Text('Security'),
                    subtitle: Text('Manage your security settings'),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                  CupertinoListTile(
                    title: Text('Help'),
                    subtitle: Text('Get help'),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                  CupertinoListTile(
                    title: Text('About'),
                    subtitle: Text('About the app'),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                ],
              ),
              CupertinoButton.filled(
                child: const Text("Logout"),
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
