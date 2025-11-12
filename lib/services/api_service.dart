import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:coins_sphere/models/coin.dart';

class ApiService {
  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.coingecko.com/api/v3',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              headers: const {'Accept': 'application/json'},
            ),
          );

  final Dio _dio;
  // Simple in-memory cache for chart results during app runtime.
  // Key format: '<coinId>:<days>'
  final Map<String, List<double>> _chartCache = <String, List<double>>{};

  /// Fetch coin markets and parse JSON into `List<Coin>` on a background isolate
  Future<List<Coin>> fetchCoinMarkets() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/coins/markets',
        queryParameters: const <String, dynamic>{
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': 100,
          'page': 1,
          'sparkline': true,
          'price_change_percentage': '24h',
        },
      );

      final data = response.data;
      if (data == null) {
        return <Coin>[];
      }

      // Offload the JSON -> model parsing + downsampling to a background isolate
      return compute<List<dynamic>, List<Coin>>(_parseCoinList, data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.statusMessage ?? e.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch coin markets${status != null ? ' (HTTP $status)' : ''}: $message',
      );
    } catch (e) {
      throw Exception('Failed to fetch coin markets: $e');
    }
  }

  /// Fetch market chart prices and parse them on a background isolate
  Future<List<double>> fetchCoinMarketChart(String coinId, int days) async {
    try {
      final cacheKey = '$coinId:$days';
      if (_chartCache.containsKey(cacheKey)) {
        // Return a defensive copy to avoid accidental mutation by callers
        debugPrint('ApiService: returning cached chart for $cacheKey');
        return List<double>.from(_chartCache[cacheKey]!);
      }
      final response = await _dio.get<Map<String, dynamic>>(
        '/coins/$coinId/market_chart',
        queryParameters: <String, dynamic>{'vs_currency': 'usd', 'days': days},
      );

      final data = response.data;
      if (data == null) return <double>[];
      final prices = data['prices'] as List<dynamic>? ?? const [];

      // Offload price list parsing to background isolate
      final parsed = await compute<List<dynamic>, List<double>>(
        _parsePrices,
        prices,
      );

      // Cache the parsed result for faster subsequent loads during this session
      try {
        _chartCache[cacheKey] = List<double>.from(parsed);
      } catch (_) {
        // If caching fails for any reason, ignore and continue — not critical
      }

      return parsed;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.statusMessage ?? e.message ?? 'Unknown error';
      throw Exception(
        'Failed to fetch market chart${status != null ? ' (HTTP $status)' : ''}: $message',
      );
    } catch (e) {
      throw Exception('Failed to fetch market chart: $e');
    }
  }
}

// Downsample helper: reduce the number of points to at most [maxPoints]
List<double> _downsampleList(List<dynamic> raw, int maxPoints) {
  final values = raw
      .whereType<num>()
      .map((n) => n.toDouble())
      .toList(growable: false);
  final len = values.length;
  if (len <= maxPoints) return values;
  final step = len / maxPoints;
  final out = <double>[];
  for (var i = 0; i < maxPoints; i++) {
    final idx = (i * step).floor().clamp(0, len - 1);
    out.add(values[idx]);
  }
  return out;
}

// Top-level parse functions used with compute()
List<Coin> _parseCoinList(List<dynamic> data) {
  const maxSparklinePoints = 64; // reduce points to speed up chart rendering

  final coins = <Coin>[];
  for (final raw in data.whereType<Map<String, dynamic>>()) {
    // Copy the map so we can replace sparkline data without mutating source
    final Map<String, dynamic> copy = Map<String, dynamic>.from(raw);

    final sparkRaw =
        (raw['sparkline_in_7d']?['price'] as List<dynamic>?) ??
        const <dynamic>[];
    if (sparkRaw.isNotEmpty) {
      copy['sparkline_in_7d'] = {
        'price': _downsampleList(sparkRaw, maxSparklinePoints),
      };
    }

    coins.add(Coin.fromJson(copy));
  }

  return coins;
}

List<double> _parsePrices(List<dynamic> prices) {
  return prices
      .whereType<List<dynamic>>()
      .map((entry) {
        final num? value = entry.length > 1
            ? (entry[1] as num?)
            : (entry.isNotEmpty ? (entry[0] as num?) : 0);
        return (value ?? 0).toDouble();
      })
      .toList(growable: false);
}
