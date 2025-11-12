import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:coins_sphere/models/coin.dart';
import 'package:coins_sphere/providers/coin_provider.dart';
import 'package:coins_sphere/widgets/coin_chart.dart';

class CoinDetailScreen extends ConsumerWidget {
  static const String routeName = '/coin_detail';

  final Coin coin;
  const CoinDetailScreen({Key? key, required this.coin}) : super(key: key);

  static const List<String> _ranges = <String>['24H', '7D', '1M', '1Y'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFmt = NumberFormat.simpleCurrency(decimalDigits: 2);
    final neon = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderCard(coin: coin),
            const SizedBox(height: 16),
            _buildTimeSelector(neon, ref),
            const SizedBox(height: 12),
            // Pass ref into CoinChart so it can read providers directly if needed
            CoinChart(coin: coin, ref: ref),
            const SizedBox(height: 16),
            _buildMarketStatsCard(coin, priceFmt),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(Color neon, WidgetRef ref) {
    final current = ref.watch(chartRangeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_ranges.length, (i) {
        final v = _ranges[i];
        final selected = v == current;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: selected ? neon.withOpacity(0.12) : Colors.transparent,
                side: BorderSide(color: selected ? neon : Colors.white12),
                foregroundColor: selected ? neon : Colors.white70,
              ),
              onPressed: () => ref.read(chartRangeProvider.notifier).state = v,
              child: Text(v, style: const TextStyle(fontSize: 12)),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMarketStatsCard(Coin coin, NumberFormat fmt) {
    return Card(
      color: const Color(0xFF0B1220),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Market Stats', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MarketStatTile(title: 'Market Cap', value: fmt.format(coin.marketCap)),
                _MarketStatTile(title: '24h Volume', value: fmt.format(coin.totalVolume)),
                _MarketStatTile(title: 'Circulating', value: fmt.format(coin.circulatingSupply)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Coin coin;
  const _HeaderCard({Key? key, required this.coin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceFmt = NumberFormat.simpleCurrency(decimalDigits: 2);
    final change = coin.priceChangePercentage24h;
    final changeColor = change >= 0 ? Colors.greenAccent : Colors.redAccent;

    return Card(
      color: const Color(0xFF0B1220),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(coin.image),
              radius: 28,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${coin.name} (${coin.symbol})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(priceFmt.format(coin.currentPrice), style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${change.toStringAsFixed(2)}%', style: TextStyle(color: changeColor)),
                const SizedBox(height: 6),
                Text('Rank ${coin.marketCapRank ?? '-'}', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketStatTile extends StatelessWidget {
  final String title;
  final String value;
  const _MarketStatTile({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
