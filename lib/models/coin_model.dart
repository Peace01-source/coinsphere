class Coin {
final String id;
final String symbol;
final String name;
final String image;
final double currentPrice;
final double marketCap;
final double totalVolume;
final double circulatingSupply;
final int? marketCapRank;
final double priceChangePercentage24h;
final double ath;
final List<double> sparkline;

Coin({
required this.id,
required this.symbol,
required this.name,
required this.image,
required this.currentPrice,
required this.marketCap,
required this.totalVolume,
required this.circulatingSupply,
required this.marketCapRank,
required this.priceChangePercentage24h,
required this.ath,
this.sparkline = const <double>[],
});

factory Coin.fromJson(Map<String, dynamic> json) {
// Safely parse the sparkline data
final sparklineData = (json['sparkline_in_7d']?['price'] as List<dynamic>?) ?? const <dynamic>[];

return Coin(
  id: json['id'] as String? ?? '',
  symbol: (json['symbol'] as String? ?? '').toUpperCase(),
  name: json['name'] as String? ?? '',
  image: json['image'] as String? ?? '',
  currentPrice: (json['current_price'] as num? ?? 0).toDouble(),
  marketCap: (json['market_cap'] as num? ?? 0).toDouble(),
  totalVolume: (json['total_volume'] as num? ?? 0).toDouble(),
  circulatingSupply:
      (json['circulating_supply'] as num? ?? 0).toDouble(),
  marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
  priceChangePercentage24h:
      (json['price_change_percentage_24h'] as num? ?? 0).toDouble(),
  ath: (json['ath'] as num? ?? 0).toDouble(),
  // Safely map the sparkline data to a list of doubles
  sparkline: sparklineData.map<double>((e) => (e as num? ?? 0).toDouble()).toList(),
);


}
}