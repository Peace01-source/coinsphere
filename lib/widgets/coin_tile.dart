import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coins_sphere/models/coin.dart';

class CoinTile extends StatelessWidget {
  final Coin coin;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  const CoinTile({
    super.key,
    required this.coin,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final coin = this.coin;
    final isUp = coin.priceChangePercentage24h >= 0;
    final theme = Theme.of(context);
    final neon = theme.colorScheme.primary;
    
    final priceChangeColor = isUp ? Colors.greenAccent : Colors.redAccent;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
             border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.18),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Coin image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: coin.image,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    width: 44,
                    height: 44,
                    color: Colors.white10,
                    child: const Icon(
                      Icons.currency_bitcoin,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coin.symbol.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
               Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Text(
                      '\$${coin.currentPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${isUp ? '▲' : '▼'} ${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: priceChangeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                 ],
               ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onToggleFavorite,
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    isFavorite
                        ? Icons.star
                        : Icons.star_border_rounded,
                    color: isFavorite ? neon : Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}