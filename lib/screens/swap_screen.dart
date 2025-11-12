import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:cached_network_image/cached_network_image.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  bool _detailsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () { /* TODO: Show transaction history */ },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Swap Input Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('You Pay', style: textTheme.titleMedium?.copyWith(color: Colors.white70)),
                Text('You Get', style: textTheme.titleMedium?.copyWith(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _CoinInputBox(
                  coin: 'ETH',
                  amount: '1.5',
                  value: '~ \$4,500.00',
                  iconUrl: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    onPressed: () { /* TODO: Swap logic */ },
                    mini: true,
                    backgroundColor: const Color(0xFF161D30),
                    child: Icon(Icons.swap_horiz, color: theme.colorScheme.primary),
                  ),
                ),
                _CoinInputBox(
                  coin: 'USDC',
                  amount: '4,485.5',
                  value: '~ \$4,485.50',
                  iconUrl: 'https://assets.coingecko.com/coins/images/6319/large/usdc.png',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Balance: 1.5 ETH',
              style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 32),
            
            // --- Live Price Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ETH/USDC Live Price',
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '+1.25%',
                  style: textTheme.titleMedium?.copyWith(color: Colors.greenAccent),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: _LiveChart(), // Placeholder chart
            ),
            const SizedBox(height: 24),

            // --- Transaction Details ---
            ExpansionTile(
              title: Text(
                'Transaction Details',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white70,
              onExpansionChanged: (expanded) {
                setState(() => _detailsExpanded = expanded);
              },
              children: [
                _DetailRow(label: 'Rate', value: '1 ETH = 2,990.33 USDC'),
                _DetailRow(label: 'Network Fee', value: '~ \$5.50'),
                _DetailRow(label: 'Slippage', value: '0.5%'),
              ],
            ),
          ],
        ),
      ),
      // --- Review Swap Button ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton(
          onPressed: () { /* TODO: Review Swap Logic */ },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Review Swap',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// --- Reusable UI Components for Swap Screen ---
class _CoinInputBox extends StatelessWidget {
  final String coin;
  final String amount;
  final String value;
  final String iconUrl;

  const _CoinInputBox({
    required this.coin,
    required this.amount,
    required this.value,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161D30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () { /* TODO: Show coin selector */ },
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12, 
                    backgroundColor: Colors.transparent,
                    child: CachedNetworkImage(imageUrl: iconUrl)
                  ),
                  const SizedBox(width: 8),
                  Text(coin, style: Theme.of(context).textTheme.titleLarge),
                  const Icon(Icons.expand_more, color: Colors.white70, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LiveChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder data to mimic the design
    final spots = [
      FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 2.5), FlSpot(3, 5), FlSpot(4, 4.5),
      FlSpot(5, 6), FlSpot(6, 5), FlSpot(7, 7), FlSpot(8, 6), FlSpot(9, 6.5),
      FlSpot(10, 5), FlSpot(11, 4.5), FlSpot(12, 6), FlSpot(13, 7.5),
    ];
    final color = Theme.of(context).colorScheme.primary;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0, maxX: 13, minY: 0, maxY: 8,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}