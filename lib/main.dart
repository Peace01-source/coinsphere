import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coins_sphere/models/coin.dart';

// Import all your screens for the route generator and navigation
// Make sure these paths are correct for your folder structure
import 'package:coins_sphere/screens/coin_detail_screen.dart';
import 'package:coins_sphere/screens/main_navigation_screen.dart';
import 'package:coins_sphere/screens/coin_list_screen.dart';
import 'package:coins_sphere/screens/wallet_screen.dart';
import 'package:coins_sphere/screens/swap_screen.dart';
import 'package:coins_sphere/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Wrap the entire app in a ProviderScope for Riverpod state management
  runApp(const ProviderScope(child: CoinSphereApp()));
}

class CoinSphereApp extends StatelessWidget {
  const CoinSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the app's base theme
    final baseTheme = ThemeData.dark(useMaterial3: true);
    // Define the primary accent color from your designs
    final neonAccent = const Color(0xFF00E5FF);

    return MaterialApp(
      title: 'CoinSphere',
      debugShowCheckedModeBanner: false,

      // --- THIS IS THE CRITICAL LINE ---
      // This sets the starting page of your app to the navigation screen.
      home: const MainNavigationScreen(),

      // Define the dark theme to match your "Web3" design
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1E), // Deep navy blue
        primaryColor: neonAccent,
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: neonAccent,
          secondary: const Color(
            0xFFE000FF,
          ), // Pink/Magenta for settings button
          background: const Color(0xFF0A0F1E), // Deep navy
          surface: const Color(0xFF161D30), // Lighter navy for cards
          onSurface: Colors.white,
          onPrimary: Colors.black, // Text on primary buttons
        ),
        textTheme: baseTheme.textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        // Theme for all AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0F1E),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Theme for the Bottom Navigation Bar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF0F1628), // Dark navy bg
          selectedItemColor: neonAccent,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        // Theme for input fields (like the search bar)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF161D30),
          hintStyle: const TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: neonAccent, width: 2),
          ),
        ),
      ),

      // This 'onGenerateRoute' handles navigating to new pages,
      // like when you tap on a coin to see its details.
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // This rule handles opening the CoinDetailScreen
          case CoinDetailScreen.routeName:
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) =>
                  CoinDetailScreen(coin: settings.arguments as Coin),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Slide-up and fade-in transition
                    final tween = Tween(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic));
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      ),
                    );
                  },
            );

          // Define routes for all your main screens
          case '/coins':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const CoinListScreen(),
            );
          case '/wallet':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const WalletScreen(),
            );
          case '/swap':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SwapScreen(),
            );
          case '/settings':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SettingsScreen(),
            );

          // Default route (if something goes wrong, show the home screen)
          default:
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const MainNavigationScreen(),
              transitionsBuilder: (context, animation, _, child) =>
                  FadeTransition(opacity: animation, child: child),
            );
        }
      },
    );
  }
}
