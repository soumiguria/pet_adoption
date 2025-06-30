import 'package:flutter/material.dart';
import 'app.dart';
import 'splash_screen.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Adoption App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const PetAdoptionApp(),
      },
    );
  }
}
