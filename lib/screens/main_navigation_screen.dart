import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your 4 main screens
import 'coin_list_screen.dart'; 
import 'wallet_screen.dart';
import 'swap_screen.dart';
import 'settings_screen.dart';

// Provider to keep track of the selected page index
final pageIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  // List of all the pages accessible from the bottom nav bar
  final List<Widget> _pages = const [
    CoinListScreen(), // Your "Coins" page (index 0)
    WalletScreen(),   // Your "Wallet" page (index 1)
    SwapScreen(),     // Your "Swap" page (index 2)
    SettingsScreen(), // Your "Settings" page (index 3)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedIndex = ref.watch(pageIndexProvider);

    return Scaffold(
      // Use IndexedStack to keep the state of each page alive
      // when switching tabs.
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => ref.read(pageIndexProvider.notifier).state = index,
        
        // Styling is now inherited from main.dart's theme
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            label: 'Coins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded),
            label: 'Swap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}