import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/pages/profile_page/profile_tabs.dart';

import '../../providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              backgroundColor: Color(0xFF252735),
              pinned: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gymly'),
                  GestureDetector(
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 28,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SliverAppBar(
              expandedHeight: 240,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: ProfileSection(
                  userName: auth.user?.name ?? '-',
                  userEmail: auth.user?.email ?? '-',
                  imageUrl: '',
                ),
              ),
            ),
            const SliverAppBar(
              pinned: true,
              // expandedHeight: 20,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(background: ProfileTabs()),
            ),
            SliverToBoxAdapter(
                child: SizedBox(
                    height: 800,
                    width: MediaQuery.of(context).size.width - 10,
                    child: TabBarView(children: [
                      Column(
                        children: [
                          Text(auth.user!.sub),
                          Text(auth.user!.name),
                          Text(auth.user!.email),
                          Text(auth.accessToken!),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                            },
                            child: const Text("Logout"),
                          )
                        ],
                      ),
                      Text("asd2"),
                    ])))
          ]),
        ));
  }
}
