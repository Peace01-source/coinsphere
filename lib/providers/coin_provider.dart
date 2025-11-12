import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:coins_sphere/models/coin.dart';
import 'package:coins_sphere/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final coinListProvider = FutureProvider<List<Coin>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchCoinMarkets();
});

// Stores the currently selected time range string (e.g., "7D")
final chartRangeProvider = StateProvider<String>((ref) => '7D');

/// Small value object used as the family key for chart requests
class ChartRequest {
  final String coinId;
  final int days;

  const ChartRequest(this.coinId, this.days);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartRequest && other.coinId == coinId && other.days == days;
  }

  @override
  int get hashCode => Object.hash(coinId, days);
}

/// Provider that fetches market chart prices for a specific coin and days.
/// The UI will supply a ChartRequest key so it can control when requests
/// happen (enables debouncing at the UI level).
final coinMarketChartProvider = FutureProvider.family<List<double>, ChartRequest>((
  ref,
  req,
) async {
  final api = ref.watch(apiServiceProvider);
  if (req.coinId.isEmpty) return <double>[];

  try {
    return await api.fetchCoinMarketChart(req.coinId, req.days);
  } catch (e, st) {
    debugPrint(
      'coinMarketChartProvider error for ${req.coinId} (days=${req.days}): $e\n$st',
    );
    return <double>[]; // return empty list so UI can fall back gracefully
  }
});
