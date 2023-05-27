import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gymly/constants/colors.dart';
import 'package:gymly/pages/add_post_page/add_post_page.dart';
import 'package:gymly/pages/body_measurements_page.dart';
import 'package:gymly/pages/unknown_route_page.dart';
import 'package:gymly/pages/user_workout_programs_page/user_workout_programs_page.dart';
import 'package:gymly/pages/welcome_page.dart';
import 'package:gymly/providers/auth_provider.dart';
import 'package:gymly/providers/storage_provider.dart';
import './pages/login_page.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

import 'pages/home_page.dart';

// For development certificate errors
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FlutterSecureStorage storage = ref.read(storageProvider);
    final auth = ref.read(authProvider.notifier);
    final isAuth = ref.watch(authProvider).isAuth;
    final isFirstLogin = ref.watch(authProvider).isFirstLogin;

    checkAuth() async {
      if (isAuth) return true;

      final refreshToken = await storage.read(key: "refreshToken");
      final refreshTokenExprDateTimeStr =
          await storage.read(key: "refreshTokenExprDateTime");
      if (refreshToken == null || refreshTokenExprDateTimeStr == null) {
        return false;
      }

      final refreshTokenExprDateTime =
          DateTime.parse(refreshTokenExprDateTimeStr);
      if (refreshTokenExprDateTime.isBefore(DateTime.now())) return false;

      return await auth.refresh(refreshToken: refreshToken);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: textColorWhite,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 1.5, color: textColorWhite, style: BorderStyle.solid),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        )),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: textColorWhite,
          modalElevation: 22,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        ),
        iconTheme: IconThemeData(color: textColorWhite),
        primaryIconTheme: IconThemeData(color: textColorWhite),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          actionsIconTheme: IconThemeData(color: textColorWhite),
          foregroundColor: textColorWhite,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedIconTheme: IconThemeData(color: textColorWhite),
          selectedIconTheme: IconThemeData(color: textColorWhite),
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        tabBarTheme: const TabBarTheme(
          labelStyle: TextStyle(fontSize: 14),
          indicatorColor: Colors.cyanAccent,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      home: FutureBuilder(
        future: checkAuth(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final authState = snapshot.data!;
            if (!authState) return LoginPage();
            if (isFirstLogin != null && isFirstLogin) {
              return const WelcomePage();
            } else {
              return const HomePage();
            }
          } else if (snapshot.hasError) {
            return LoginPage();
          }
          return LoginPage();
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginPage.routeName:
            return MaterialPageRoute(
                builder: (ctx) => LoginPage(), settings: settings);
          case HomePage.routeName:
            return MaterialPageRoute(
                builder: (ctx) => const HomePage(), settings: settings);
          case WelcomePage.routeName:
            return MaterialPageRoute(
                builder: (ctx) => const WelcomePage(), settings: settings);
          case AddPostPage.routeName:
            return MaterialPageRoute(
                builder: (ctx) => const AddPostPage(), settings: settings);
          case BodyMeasurementsPage.routeName:
            {
              final arguments = settings.arguments;
              bool firstLogin = false;
              if (arguments != null) {
                firstLogin =
                    (arguments as Map<String, bool>)["firstLogin"] ?? false;
              }
              return MaterialPageRoute(
                  builder: (ctx) =>
                      BodyMeasurementsPage(firstLogin: firstLogin),
                  settings: settings);
            }
          case UserWorkoutProgramsPage.routeName:
            return MaterialPageRoute(
                builder: (ctx) => const UserWorkoutProgramsPage(),
                settings: settings);
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => const UnknownRoutePage());
      },
    );
  }
}
