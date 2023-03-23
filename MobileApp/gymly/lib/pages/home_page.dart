import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/pages/profile_page/profile_page.dart';
import 'package:gymly/providers/auth_provider.dart';
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
    const Text(
      'Home',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Chat',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Workout',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      /*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(auth.user!.sub),
            // Text(auth.user!.name),
            // Text(auth.user!.email),
            // Text(auth.accessToken!),
            // ElevatedButton(
            //   onPressed: () {
            //     ref.read(authProvider.notifier).logout();
            //   },
            //   child: const Text("Logout"),
            // )
          ],
        ),
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        iconSize: 30,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: primaryDarkColor,
              icon: Column(children: [
                const Icon(Icons.home_rounded),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 2),
                  width: _selectedIndex == 0 ? 24 : 0,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Color(0xFF81B4FF),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ]),
              label: ""),
          BottomNavigationBarItem(
              backgroundColor: primaryDarkColor,
              icon: Column(children: [
                const Icon(Icons.chat_bubble_rounded),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 2),
                  width: _selectedIndex == 1 ? 24 : 0,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Color(0xFF81B4FF),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ]),
              label: ""),
          BottomNavigationBarItem(
              backgroundColor: primaryDarkColor,
              icon: Column(children: [
                const Icon(Icons.fitness_center_rounded),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 2),
                  width: _selectedIndex == 2 ? 24 : 0,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Color(0xFF81B4FF),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ]),
              label: ""),
          BottomNavigationBarItem(
            backgroundColor: primaryDarkColor,
            icon: Column(children: [
              const Icon(Icons.person_rounded),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 2),
                width: _selectedIndex == 3 ? 24 : 0,
                height: 4,
                decoration: const BoxDecoration(
                    color: Color(0xFF81B4FF),
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
