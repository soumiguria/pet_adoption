import 'package:flutter/material.dart';
import 'features/home/home_page.dart';
import 'features/details/details_page.dart';
import 'features/history/history_page.dart';
import 'features/favorites/favorites_page.dart';
import 'core/models/pet.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: const Color(0xFFF8F4FF),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.deepPurple,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.deepPurple),
    titleTextStyle: TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.bold,
      fontSize: 22,
      letterSpacing: 1.2,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    elevation: 4,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: Colors.pinkAccent,
    primary: Colors.deepPurple,
    background: const Color(0xFFF8F4FF),
    surface: Colors.white,
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
    headlineSmall: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.deepPurple,
    ),
    titleMedium: const TextStyle(fontSize: 16, color: Colors.black54),
    bodyMedium: const TextStyle(fontSize: 15, color: Colors.black87),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.pinkAccent,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple[200],
  scaffoldBackgroundColor: const Color(0xFF23213A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2D284B),
    foregroundColor: Colors.pinkAccent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.pinkAccent),
    titleTextStyle: TextStyle(
      color: Colors.pinkAccent,
      fontWeight: FontWeight.bold,
      fontSize: 22,
      letterSpacing: 1.2,
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF2D284B),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    elevation: 4,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ),
  colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
    secondary: Colors.pinkAccent,
    primary: Colors.deepPurple[200],
    background: const Color(0xFF23213A),
    surface: const Color(0xFF2D284B),
  ),
  textTheme: ThemeData.dark().textTheme.copyWith(
    headlineSmall: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.pinkAccent,
    ),
    titleMedium: const TextStyle(fontSize: 16, color: Colors.white70),
    bodyMedium: const TextStyle(fontSize: 15, color: Colors.white),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.pinkAccent,
  ),
);

class PetAdoptionApp extends StatelessWidget {
  const PetAdoptionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => const HomePage()},
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final pet = settings.arguments as Pet;
          return PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    DetailsPage(pet: pet),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        }
        if (settings.name == '/history') {
          return PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const HistoryPage(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        }
        if (settings.name == '/favorites') {
          return PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const FavoritesPage(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        }
        return null;
      },
    );
  }
}
