import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymly/providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    const List<Widget> _widgetOptions = <Widget>[
      Text(
        'Home',
        style: optionStyle,
      ),
      Text(
        'Chat',
        style: optionStyle,
      ),
      Text(
        'Workout',
        style: optionStyle,
      ),
      Text(
        'Profile',
        style: optionStyle,
      ),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
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
        // backgroundColor: Color(0xFF18122B),
        currentIndex: _selectedIndex,
        iconSize: 30,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF18122B),
              icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                  weight: 100),
              label: "-----"),
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF18122B),
              icon: Icon(_selectedIndex == 1
                  ? Icons.chat_bubble
                  : Icons.chat_bubble_outline_outlined),
              label: "-----"),
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF18122B),
              icon: Icon(_selectedIndex == 2
                  ? Icons.fitness_center
                  : Icons.fitness_center_outlined),
              label: "-----"),
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF18122B),
              icon: Icon(_selectedIndex == 3
                  ? Icons.person
                  : Icons.person_outline_outlined),
              label: "-----"),
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
