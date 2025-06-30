import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnim = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(32),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Pet Adoption',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Find your new best friend!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
