import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/pages/profile_page/profile_section.dart';
import 'package:gymly/pages/profile_page/profile_tabs.dart';
import 'package:gymly/providers/user_provider.dart';

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
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                )
              ],
              backgroundColor: Colors.black,
              pinned: true,
              title: Text(
                'Gymly',
                style: TextStyle(color: textColorWhite),
              ),
            ),
            SliverAppBar(
              expandedHeight: 240,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: ProfileSection(
                  userName: auth.user?.name ?? '-',
                  userEmail: auth.user?.email ?? '-',
                  imageUrl: '',
                ),
              ),
            ),
            SliverAppBar(
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
                          OutlinedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                            },
                            child: const Text("Logout"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              ref.read(userProvider).getUser().then((value) {
                                // print(
                                //     "LOG: ${value.dateOfBirth.toIso8601String()}");
                                // print("LOG: ${value.gender}");
                              });
                            },
                            child: const Text("GetData"),
                          )
                        ],
                      ),
                      Center(child: Text("asd2")),
                    ])))
          ]),
        ));
  }
}
