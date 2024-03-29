import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/chat_page/chat_page.dart';
import 'package:gymly/pages/gym_page/add_workout_page.dart';
import 'package:gymly/pages/gym_page/gym_page.dart';
import 'package:gymly/pages/posts_page/posts_page.dart';
import 'package:gymly/pages/profile_page/profile_page.dart';
import 'package:gymly/pages/add_post_page/add_post_page.dart';
import 'package:gymly/pages/welcome_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/chat_provider.dart';
import 'package:gymly/providers/hub_connection_provider.dart';
import '../constants/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const PostsPage(),
    const ChatPage(),
    const GymPage(),
    const ProfilePage(),
  ];

  PreferredSizeWidget? buildAppBar(context) {
    if (_selectedIndex == 3) {
      return null;
    } else {
      return AppBar(
        title: const Text("Gymly"),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPostPage.routeName);
              },
              icon: const Icon(Icons.add),
            ),
          if (_selectedIndex == 2)
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddWorkoutPage.routeName);
              },
              icon: const Icon(Icons.fitness_center_rounded),
            )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future(() async {
      await ref.watch(hubConnectionProvider.notifier).connect();

      await ref
          .watch(hubConnectionProvider.notifier)
          .joinChat(ref.watch(authProvider).user!.sub);

      await ref.watch(hubConnectionProvider.notifier).assignChatChannelFunction(
          ref.watch(chatProvider.notifier).getMessage);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _pages[_selectedIndex],
      ),
      appBar: buildAppBar(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        iconSize: 30,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Column(children: [
                const Icon(Icons.home_rounded),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 2),
                  width: _selectedIndex == 0 ? 24 : 0,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ]),
              label: ""),
          BottomNavigationBarItem(
              icon: Column(children: [
                const Icon(Icons.chat_bubble_rounded),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 2),
                  width: _selectedIndex == 1 ? 24 : 0,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ]),
              label: ""),
          BottomNavigationBarItem(
              icon: Column(children: [
                const Icon(Icons.fitness_center_rounded),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 2),
                  width: _selectedIndex == 2 ? 24 : 0,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ]),
              label: ""),
          BottomNavigationBarItem(
            icon: Column(children: [
              const Icon(Icons.person_rounded),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 2),
                width: _selectedIndex == 3 ? 24 : 0,
                height: 4,
                decoration: const BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ]),
            label: "",
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
