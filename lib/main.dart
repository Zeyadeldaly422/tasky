import 'package:flutter/material.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
// ignore: unused_import
import 'package:todoapp/core/theme/dark_theme.dart';
// ignore: unused_import
import 'package:todoapp/core/theme/light_theme.dart';
import 'package:todoapp/core/theme/theme_controller.dart';
import 'package:todoapp/screens/main_screen.dart';
import 'package:todoapp/screens/welcome_screen.dart';


// ValueNotifier<ThemeMode> themeNotifier =ValueNotifier(ThemeMode.dark);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesManager().init();
  ThemeController().toString();
// bool result = PreferencesManager().getBool("theme") ?? true ;
// if (result == true){themeNotifier.value =ThemeMode.dark;}
// else {themeNotifier.value =ThemeMode.light;}
  String? username = PreferencesManager().getString('username');

  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode themeMode, Widget? child) {
        return MaterialApp(
          title: 'Tasky',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode:themeMode,
          home: username == null ? WelcomeScreen() : MainScreen(),
        );
      },
    );
  }
}