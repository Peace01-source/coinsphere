import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coins_sphere/models/coin.dart';
import 'package:coins_sphere/providers/coin_provider.dart';

class CoinChart extends ConsumerWidget {
  final Coin coin;
  final WidgetRef ref;

  const CoinChart({Key? key, required this.coin, required this.ref})
    : super(key: key);

  /// Map range display strings to API days parameter
  int _getRangeValue(String range) {
    return switch (range) {
      '24H' => 1,
      '7D' => 7,
      '1M' => 30,
      '1Y' => 365,
      _ => 7,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected chart range from the provider
    final rangeDisplay = ref.watch(chartRangeProvider);
    final days = _getRangeValue(rangeDisplay);

    // Fetch chart data based on the selected range
    final chartAsync = ref.watch(
      coinMarketChartProvider(ChartRequest(coin.id, days)),
    );

    return Card(
      color: const Color(0xFF0F1628),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 220,
          child: chartAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFBF360C)),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load chart',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    error.toString().replaceFirst('Exception: ', ''),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            data: (prices) {
              if (prices.isEmpty) {
                return Center(
                  child: Text(
                    'No chart data available',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }

              final minPrice = prices.reduce((a, b) => a < b ? a : b);
              final maxPrice = prices.reduce((a, b) => a > b ? a : b);
              final priceChange = prices.last - prices.first;
              final isPositive = priceChange >= 0;
              final changeColor = isPositive
                  ? Colors.greenAccent
                  : Colors.redAccent;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price range info
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Min: \$${minPrice.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Change: ${priceChange.toStringAsFixed(2)} (${((priceChange / prices.first) * 100).toStringAsFixed(2)}%)',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: changeColor),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Max: \$${maxPrice.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Now: \$${prices.last.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Simple bar chart representation
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: CustomPaint(
                            size: Size(double.infinity, double.infinity),
                            painter: _SimpleChartPainter(
                              prices: prices,
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                              lineColor: changeColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Simple custom painter to draw a line chart
class _SimpleChartPainter extends CustomPainter {
  final List<double> prices;
  final double minPrice;
  final double maxPrice;
  final Color lineColor;

  _SimpleChartPainter({
    required this.prices,
    required this.minPrice,
    required this.maxPrice,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final range = maxPrice - minPrice;
    final widthPerPoint = size.width / (prices.length - 1).toDouble();

    Path path = Path();
    for (int i = 0; i < prices.length; i++) {
      final price = prices[i];
      final normalized = (price - minPrice) / range;
      final x = i * widthPerPoint;
      final y = size.height - (normalized * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw start and end points
    final startNormalized = (prices.first - minPrice) / range;
    final startY = size.height - (startNormalized * size.height);
    canvas.drawCircle(Offset(0, startY), 4, paint);

    final endNormalized = (prices.last - minPrice) / range;
    final endY = size.height - (endNormalized * size.height);
    canvas.drawCircle(Offset(size.width, endY), 4, paint);
  }

  @override
  bool shouldRepaint(_SimpleChartPainter oldDelegate) {
    return oldDelegate.prices != prices || oldDelegate.lineColor != lineColor;
  }
}
