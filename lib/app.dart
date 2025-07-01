import 'package:flutter/material.dart';
import 'features/home/home_page.dart';
import 'features/details/details_page.dart';
import 'features/history/history_page.dart';
import 'features/favorites/favorites_page.dart';
import 'core/models/pet.dart';
import 'core/notifiers/theme_mode_notifier.dart';

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

// WebScaffold: wraps content with a static app bar for web
class WebScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex; // 0: Home, 1: History, 2: Favorites
  const WebScaffold({
    required this.child,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          color: theme.appBarTheme.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Row(
                children: [
                  Icon(Icons.pets, color: Colors.deepPurple, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'Pet Adoption',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _WebNavButton(
                label: 'Home',
                icon: Icons.home,
                selected: selectedIndex == 0,
                onTap: () => Navigator.pushNamed(context, '/'),
              ),
              _WebNavButton(
                label: 'History',
                icon: Icons.history,
                selected: selectedIndex == 1,
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
              _WebNavButton(
                label: 'Favorites',
                icon: Icons.favorite,
                selected: selectedIndex == 2,
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
              // Theme toggle button for web
              IconButton(
                icon: Icon(_themeIcon(themeModeNotifier.value)),
                tooltip: _themeTooltip(themeModeNotifier.value),
                onPressed: _toggleThemeMode,
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }

  void _toggleThemeMode() {
    if (themeModeNotifier.value == ThemeMode.system) {
      themeModeNotifier.value = ThemeMode.light;
    } else if (themeModeNotifier.value == ThemeMode.light) {
      themeModeNotifier.value = ThemeMode.dark;
    } else {
      themeModeNotifier.value = ThemeMode.system;
    }
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      default:
        return Icons.brightness_auto;
    }
  }

  String _themeTooltip(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      default:
        return 'System Default';
    }
  }
}

class _WebNavButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _WebNavButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_WebNavButton> createState() => _WebNavButtonState();
}

class _WebNavButtonState extends State<_WebNavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    await Future.delayed(const Duration(milliseconds: 75));
    if (mounted) {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor:
                      widget.selected
                          ? Colors.deepPurple
                          : theme.textTheme.titleMedium?.color,
                  backgroundColor:
                      widget.selected
                          ? Colors.deepPurple.withOpacity(0.08)
                          : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onPressed: _handleTap,
                icon: Icon(widget.icon, size: 20),
                label: Text(
                  widget.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom transition widget for better visual feedback
class CustomTransitionWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool isForward;

  const CustomTransitionWidget({
    Key? key,
    required this.child,
    required this.animation,
    required this.secondaryAnimation,
    required this.isForward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (animation.value * 0.05),
          child: Opacity(opacity: 0.8 + (animation.value * 0.2), child: child),
        );
      },
      child: child,
    );
  }
}

class PetAdoptionApp extends StatelessWidget {
  const PetAdoptionApp({Key? key}) : super(key: key);

  bool get _isWeb => identical(0, 0.0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Pet Adoption App',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            // Details page transition (slide up from bottom)
            if (settings.name == '/details') {
              final pet = settings.arguments as Pet;
              return PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        DetailsPage(pet: pet),
                transitionDuration: const Duration(milliseconds: 800),
                reverseTransitionDuration: const Duration(milliseconds: 600),
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

                  final reverseTween = Tween(
                    begin: end,
                    end: begin,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: SlideTransition(
                      position: secondaryAnimation.drive(reverseTween),
                      child: CustomTransitionWidget(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        isForward: true,
                        child: child,
                      ),
                    ),
                  );
                },
              );
            }

            // History page transition (slide from right)
            if (settings.name == '/history') {
              return PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        _isWeb && MediaQuery.of(context).size.width > 700
                            ? const WebScaffold(
                              child: HistoryPage(),
                              selectedIndex: 1,
                            )
                            : const HistoryPage(),
                transitionDuration: const Duration(milliseconds: 700),
                reverseTransitionDuration: const Duration(milliseconds: 700),
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

                  final reverseTween = Tween(
                    begin: end,
                    end: begin,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: SlideTransition(
                      position: secondaryAnimation.drive(reverseTween),
                      child: CustomTransitionWidget(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        isForward: true,
                        child: child,
                      ),
                    ),
                  );
                },
              );
            }

            // Favorites page transition (slide from right)
            if (settings.name == '/favorites') {
              return PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        _isWeb && MediaQuery.of(context).size.width > 700
                            ? const WebScaffold(
                              child: FavoritesPage(),
                              selectedIndex: 2,
                            )
                            : const FavoritesPage(),
                transitionDuration: const Duration(milliseconds: 700),
                reverseTransitionDuration: const Duration(milliseconds: 700),
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

                  final reverseTween = Tween(
                    begin: end,
                    end: begin,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: SlideTransition(
                      position: secondaryAnimation.drive(reverseTween),
                      child: CustomTransitionWidget(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        isForward: true,
                        child: child,
                      ),
                    ),
                  );
                },
              );
            }

            // Home page transition (slide from left when coming back)
            if (settings.name == '/') {
              return PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        _isWeb && MediaQuery.of(context).size.width > 700
                            ? const WebScaffold(
                              child: HomePage(),
                              selectedIndex: 0,
                            )
                            : const HomePage(),
                transitionDuration: const Duration(milliseconds: 700),
                reverseTransitionDuration: const Duration(milliseconds: 700),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;

                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  final reverseTween = Tween(
                    begin: end,
                    end: begin,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: SlideTransition(
                      position: secondaryAnimation.drive(reverseTween),
                      child: CustomTransitionWidget(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        isForward: false,
                        child: child,
                      ),
                    ),
                  );
                },
              );
            }

            return null;
          },
        );
      },
    );
  }
}
