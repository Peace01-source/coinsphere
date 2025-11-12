import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coins_sphere/models/coin.dart';
import 'package:coins_sphere/providers/coin_provider.dart';
import 'package:coins_sphere/widgets/coin_tile.dart';
import 'package:coins_sphere/widgets/placeholder_state.dart';
import 'package:coins_sphere/widgets/loading_widget.dart';
import 'coin_detail_screen.dart';

class CoinListScreen extends ConsumerStatefulWidget {
const CoinListScreen({super.key});

@override
ConsumerState<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends ConsumerState<CoinListScreen> {
final TextEditingController _searchController = TextEditingController();
String _query = '';

@override
void initState() {
super.initState();
_searchController.addListener(_handleSearch);
}

void _handleSearch() {
setState(() {
_query = _searchController.text.trim().toLowerCase();
});
}

@override
void dispose() {
_searchController
..removeListener(_handleSearch)
..dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final coinsAsync = ref.watch(coinListProvider);

return Scaffold(
  appBar: AppBar(title: const Text('Markets')),
  body: Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    child: Column(
      children: [
        _SearchField(controller: _searchController),
        const SizedBox(height: 16),
        Expanded(
          child: coinsAsync.when(
            loading: () => const LoadingWidget(message: 'Fetching markets...'),
            error: (error, stackTrace) => _ErrorState(
              onRetry: () => ref.invalidate(coinListProvider),
            ),
            data: (coins) => _CoinListView(coins: _filterCoins(coins)),
          ),
        ),
      ],
    ),
  ),
);


}

List<Coin> _filterCoins(List<Coin> coins) {
if (_query.isEmpty) return coins;
return coins.where((coin) {
final name = coin.name.toLowerCase();
final symbol = coin.symbol.toLowerCase();
return name.contains(_query) || symbol.contains(_query);
}).toList();
}
}

class _SearchField extends StatelessWidget {
final TextEditingController controller;
const _SearchField({required this.controller});

@override
Widget build(BuildContext context) {
return TextField(
controller: controller,
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
hintText: 'Search by name or symbol',
prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
suffixIcon: controller.text.isEmpty
? null
: IconButton(
onPressed: controller.clear,
icon: const Icon(Icons.clear, color: Colors.white54),
),
),
);
}
}

class _ErrorState extends StatelessWidget {
final VoidCallback onRetry;
const _ErrorState({required this.onRetry});

@override
Widget build(BuildContext context) {
return Center(
child: PlaceholderState(
icon: Icons.wifi_off_rounded,
title: "You're Offline",
subtitle: 'Please check your connection and try again.',
action: ElevatedButton.icon(
onPressed: onRetry,
icon: const Icon(Icons.refresh_rounded),
label: const Text('Retry'),
),
),
);
}
}

class _CoinListView extends StatelessWidget {
final List<Coin> coins;
const _CoinListView({required this.coins});

@override
Widget build(BuildContext context) {
if (coins.isEmpty) {
return const Center(
child: PlaceholderState(
icon: Icons.search_off_outlined,
title: 'No markets available',
subtitle: 'Try adjusting your search query.',
),
);
}

return ListView.builder(
  padding: const EdgeInsets.only(bottom: 24),
  itemCount: coins.length,
  itemBuilder: (context, index) {
    final coin = coins[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CoinTile(
        coin: coin,
        isFavorite: false, // TODO: Implement favorite logic
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(CoinDetailScreen.routeName, arguments: coin);
        },
        onToggleFavorite: () {
          // TODO: Implement favorite logic
        },
      ),
    );
  },
);


}
}